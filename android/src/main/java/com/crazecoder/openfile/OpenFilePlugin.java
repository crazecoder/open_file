package com.crazecoder.openfile;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.content.FileProvider;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.PermissionChecker;

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
        , ActivityAware {
    /**
     * Plugin registration.
     */
    private @Nullable
    FlutterPluginBinding flutterPluginBinding;

    private Context context;
    private Activity activity;
    private MethodChannel channel;


    private Result result;
    private String filePath;
    private String mimeType;

    private boolean isResultSubmitted = false;

    private static final String TYPE_STRING_APK = "application/vnd.android.package-archive";

    @Deprecated
    public static void registerWith(PluginRegistry.Registrar registrar) {
        OpenFilePlugin plugin = new OpenFilePlugin();
        plugin.activity = registrar.activity();
        plugin.context = registrar.context();
        plugin.channel = new MethodChannel(registrar.messenger(), "open_file");
        plugin.channel.setMethodCallHandler(plugin);
    }

    private boolean hasPermission(String permission) {
        return ContextCompat.checkSelfPermission(activity, permission) == PermissionChecker.PERMISSION_GRANTED;
    }

    @Override
    @SuppressLint("NewApi")
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        isResultSubmitted = false;
        if (call.method.equals("open_file")) {
            this.result = result;
            filePath = call.argument("file_path");
            if (call.hasArgument("type") && call.argument("type") != null) {
                mimeType = call.argument("type");
            } else {
                mimeType = getFileMimeType(filePath);
            }
            if (!isFileAvailable()) {
                return;
            }
            if (pathRequiresPermission()) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && !hasPermission(Manifest.permission.MANAGE_EXTERNAL_STORAGE)) {
                    result(-3, "Permission denied: " + Manifest.permission.MANAGE_EXTERNAL_STORAGE);
                    return;
                } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !hasPermission(Manifest.permission.READ_EXTERNAL_STORAGE)) {
                    result(-3, "Permission denied: " + Manifest.permission.READ_EXTERNAL_STORAGE);
                    return;
                }
            }
            if (TYPE_STRING_APK.equals(mimeType)) {
                openApkFile();
                return;
            }
            startActivity();
        } else {
            result.notImplemented();
            isResultSubmitted = true;
        }
    }

    private boolean pathRequiresPermission() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return false;
        }

        try {
            String appDirFilePath = context.getExternalFilesDir(null).getCanonicalPath();
            String appDirCachePath = context.getExternalCacheDir().getCanonicalPath();
            String fileCanonicalPath = new File(filePath).getCanonicalPath();
            if (fileCanonicalPath.startsWith(appDirFilePath)
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

        File file = new File(filePath);
        if (!file.exists()) {
            result(-2, "the " + filePath + " file does not exists");
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
            uri = FileProvider.getUriForFile(context, context.getPackageName() + ".fileProvider.com.crazecoder.openfile", new File(filePath));
        } else {
            uri = Uri.fromFile(new File(filePath));
        }
        intent.setDataAndType(uri, mimeType);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        List<ResolveInfo> resolveInfoList = activity.getPackageManager().queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);
        for (ResolveInfo resolveInfo : resolveInfoList) {
            String packageName = resolveInfo.activityInfo.packageName;
            activity.grantUriPermission(packageName, uri, Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
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

    private String getFileMimeType(String filePath) {
        String[] fileStrs = filePath.split("\\.");
        String fileTypeStr = fileStrs[fileStrs.length - 1].toLowerCase();
        switch (fileTypeStr) {
            case "3gp":
                return "video/3gpp";
            case "torrent":
                return "application/x-bittorrent";
            case "kml":
                return "application/vnd.google-earth.kml+xml";
            case "gpx":
                return "application/gpx+xml";
            case "apk":
                return TYPE_STRING_APK;
            case "asf":
                return "video/x-ms-asf";
            case "avi":
                return "video/x-msvideo";
            case "bin":
            case "class":
            case "exe":
                return "application/octet-stream";
            case "bmp":
                return "image/bmp";
            case "c":
                return "text/plain";
            case "conf":
                return "text/plain";
            case "cpp":
                return "text/plain";
            case "doc":
                return "application/msword";
            case "docx":
                return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            case "xls":
            case "csv":
                return "application/vnd.ms-excel";
            case "xlsx":
                return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            case "gif":
                return "image/gif";
            case "gtar":
                return "application/x-gtar";
            case "gz":
                return "application/x-gzip";
            case "h":
                return "text/plain";
            case "htm":
                return "text/html";
            case "html":
                return "text/html";
            case "jar":
                return "application/java-archive";
            case "java":
                return "text/plain";
            case "jpeg":
                return "image/jpeg";
            case "jpg":
                return "image/jpeg";
            case "js":
                return "application/x-javascript";
            case "log":
                return "text/plain";
            case "m3u":
                return "audio/x-mpegurl";
            case "m4a":
                return "audio/mp4a-latm";
            case "m4b":
                return "audio/mp4a-latm";
            case "m4p":
                return "audio/mp4a-latm";
            case "m4u":
                return "video/vnd.mpegurl";
            case "m4v":
                return "video/x-m4v";
            case "mov":
                return "video/quicktime";
            case "mp2":
                return "audio/x-mpeg";
            case "mp3":
                return "audio/x-mpeg";
            case "mp4":
                return "video/mp4";
            case "mpc":
                return "application/vnd.mpohun.certificate";
            case "mpe":
                return "video/mpeg";
            case "mpeg":
                return "video/mpeg";
            case "mpg":
                return "video/mpeg";
            case "mpg4":
                return "video/mp4";
            case "mpga":
                return "audio/mpeg";
            case "msg":
                return "application/vnd.ms-outlook";
            case "ogg":
                return "audio/ogg";
            case "pdf":
                return "application/pdf";
            case "png":
                return "image/png";
            case "pps":
                return "application/vnd.ms-powerpoint";
            case "ppt":
                return "application/vnd.ms-powerpoint";
            case "pptx":
                return "application/vnd.openxmlformats-officedocument.presentationml.presentation";
            case "prop":
                return "text/plain";
            case "rc":
                return "text/plain";
            case "rmvb":
                return "audio/x-pn-realaudio";
            case "rtf":
                return "application/rtf";
            case "sh":
                return "text/plain";
            case "tar":
                return "application/x-tar";
            case "tgz":
                return "application/x-compressed";
            case "txt":
                return "text/plain";
            case "wav":
                return "audio/x-wav";
            case "wma":
                return "audio/x-ms-wma";
            case "wmv":
                return "audio/x-ms-wmv";
            case "wps":
                return "application/vnd.ms-works";
            case "xml":
                return "text/plain";
            case "z":
                return "application/x-compress";
            case "zip":
                return "application/x-zip-compressed";
            default:
                return "*/*";
        }
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
        return activity.getPackageManager().canRequestPackageInstalls();
    }

    private void result(int type, String message) {
        if (result != null && !isResultSubmitted) {
            Map<String, Object> map = MapUtil.createMap(type, message);
            result.success(JsonUtil.toJson(map));
            isResultSubmitted = true;
        }
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        this.flutterPluginBinding = binding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        if (channel == null) {
            // Could be on too low of an SDK to have started listening originally.
            return;
        }

        channel.setMethodCallHandler(null);
        channel = null;
        this.flutterPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        channel =
                new MethodChannel(
                        flutterPluginBinding.getBinaryMessenger(), "open_file");
        context = flutterPluginBinding.getApplicationContext();
        activity = binding.getActivity();
        channel.setMethodCallHandler(this);
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
}
