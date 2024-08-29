package com.crazecoder.openfile;

import android.Manifest;
import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.content.FileProvider;
import androidx.core.content.ContextCompat;
import androidx.core.content.PermissionChecker;

import com.crazecoder.openfile.utils.FileUtil;
import com.crazecoder.openfile.utils.JsonUtil;
import com.crazecoder.openfile.utils.MapUtil;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;


/**
 * OpenFilePlugin
 */
public class OpenFilePlugin implements MethodCallHandler
        , FlutterPlugin
        , ActivityAware
        , PluginRegistry.ActivityResultListener {

    private @Nullable FlutterPluginBinding flutterPluginBinding;
    private Context context;
    private Activity activity;
    private MethodChannel channel;


    private Result result;
    private String filePath;
    private String mimeType;

    private boolean isResultSubmitted = false;

    private int REQUEST_CODE_FOR_DIR = 0x111;

    private static final String TYPE_STRING_APK = "application/vnd.android.package-archive";

    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        isResultSubmitted = false;
        if (call.method.equals("open_file")) {
            this.result = result;
            if (call.hasArgument("file_path")) {
                filePath = call.argument("file_path");
            }

            if (call.hasArgument("type") && call.argument("type") != null) {
                mimeType = call.argument("type");
            } else {
                mimeType = FileUtil.getFileMimeType(filePath);
            }
            doOpen();

        } else {
            result.notImplemented();
            isResultSubmitted = true;
        }
    }

    private void doOpen() {
        if (!isFileAvailable()) {
            return;
        }
        if (pathRequiresPermission()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU && FileUtil.isExternalStoragePublicMedia(filePath, mimeType)) {
                    if (FileUtil.isImage(mimeType) && !hasPermission(Manifest.permission.READ_MEDIA_IMAGES) && !Environment.isExternalStorageManager()) {
                        result(-3, "Permission denied: " + Manifest.permission.READ_MEDIA_IMAGES);
                        return;
                    }
                    if (FileUtil.isVideo(mimeType) && !hasPermission(Manifest.permission.READ_MEDIA_VIDEO) && !Environment.isExternalStorageManager()) {
                        result(-3, "Permission denied: " + Manifest.permission.READ_MEDIA_VIDEO);
                        return;
                    }
                    if (FileUtil.isAudio(mimeType) && !hasPermission(Manifest.permission.READ_MEDIA_AUDIO) && !Environment.isExternalStorageManager()) {
                        result(-3, "Permission denied: " + Manifest.permission.READ_MEDIA_AUDIO);
                        return;
                    }
                } else if (!Environment.isExternalStorageManager()) {
                    result(-3, "Permission denied: " + Manifest.permission.MANAGE_EXTERNAL_STORAGE);
                    return;
                }
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (!hasPermission(Manifest.permission.READ_EXTERNAL_STORAGE)) {
                    result(-3, "Permission denied: " + Manifest.permission.READ_EXTERNAL_STORAGE);
                    return;
                }

            }
        }
        if (TYPE_STRING_APK.equals(mimeType)) {
            openApkFile();
            return;
        }
        startActivity();
    }

    private boolean hasPermission(String permission) {
        return ContextCompat.checkSelfPermission(activity, permission) == PermissionChecker.PERMISSION_GRANTED;
    }

    private boolean pathRequiresPermission() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return false;
        }

        try {
            String appDirExternalFilePath = context.getExternalFilesDir(null).getCanonicalPath();
            String appDirExternalCachePath = context.getExternalCacheDir().getCanonicalPath();

            String appDirFilePath = context.getFilesDir().getCanonicalPath();
            String appDirCachePath = context.getCacheDir().getCanonicalPath();

            String fileCanonicalPath = new File(filePath).getCanonicalPath();
            if (fileCanonicalPath.startsWith(appDirExternalFilePath)
                    || fileCanonicalPath.startsWith(appDirExternalCachePath)
                    || fileCanonicalPath.startsWith(appDirFilePath)
                    || fileCanonicalPath.startsWith(appDirCachePath)) {
                return false;
            } else {
                return true;
            }
        } catch (IOException e) {
            e.printStackTrace();
            return true;
        }
    }

    private boolean isFileAvailable() {
        if (filePath == null) {
            result(-4, "the file path cannot be null");
            return false;
        }

        return true;
    }

    private void startActivity() {
        if (!isFileAvailable()) {
            return;
        }
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.addCategory(Intent.CATEGORY_DEFAULT);
        Uri uri;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            if (FileUtil.isOtherAndroidDataDir(context, filePath)) {
                uri = Uri.parse(FileUtil.changeToUri(filePath));
            } else {
                uri = FileProvider.getUriForFile(context, context.getPackageName() + ".fileProvider.com.crazecoder.openfile", new File(filePath));
            }
        } else {
            uri = Uri.fromFile(new File(filePath));
        }
        intent.setDataAndType(uri, mimeType);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        List<ResolveInfo> resolveInfoList;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            resolveInfoList = activity.getPackageManager().queryIntentActivities(intent, PackageManager.ResolveInfoFlags.of(PackageManager.MATCH_DEFAULT_ONLY));
        } else {
            resolveInfoList = activity.getPackageManager().queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);
        }
        for (ResolveInfo resolveInfo : resolveInfoList) {
            String packageName = resolveInfo.activityInfo.packageName;
            activity.grantUriPermission(packageName, uri,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION
                            | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        }
        int type = 0;
        String message = "done";
        try {
            activity.startActivity(intent);
        } catch (ActivityNotFoundException e) {
            type = -1;
            message = "No APP found to open this file。";
        } catch (Exception e) {
            type = -4;
            message = "File opened incorrectly。";
        }
        result(type, message);
    }

    private void openApkFile() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && !canInstallApk()) {
            result(-3, "Permission denied: " + Manifest.permission.REQUEST_INSTALL_PACKAGES);
        } else {
            startActivity();
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private boolean canInstallApk() {
        try {
            return activity.getPackageManager().canRequestPackageInstalls();
        } catch (SecurityException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void result(int type, String message) {
        if (result != null && !isResultSubmitted) {
            Map<String, Object> map = MapUtil.createMap(type, message);
            result.success(JsonUtil.toJson(map));
            isResultSubmitted = true;
        }
    }

    private void setMethodCallHandler() {
        if (channel == null) {
            channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "open_file");
        }
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        flutterPluginBinding = binding;
        context = binding.getApplicationContext();
        setMethodCallHandler();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        flutterPluginBinding = null;
        if (channel == null) {
            // Could be on too low of an SDK to have started listening originally.
            return;
        }

        channel.setMethodCallHandler(null);
        channel = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener(this);
        setMethodCallHandler();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {

    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            Uri uri;

            if (data == null) {
                return false;
            }

            if (requestCode == REQUEST_CODE_FOR_DIR && (uri = data.getData()) != null) {
                context.getContentResolver().takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
                doOpen();

            }
        }
        return false;
    }
}
