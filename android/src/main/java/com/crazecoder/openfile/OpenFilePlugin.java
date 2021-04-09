package com.crazecoder.openfile;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

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
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.io.File;
import java.io.IOException;
import java.util.Map;


/**
 * OpenFilePlugin
 */
public class OpenFilePlugin implements MethodCallHandler
        , FlutterPlugin
        , ActivityAware
        , PluginRegistry.RequestPermissionsResultListener
        , PluginRegistry.ActivityResultListener {
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
    private String typeString;

    private boolean isResultSubmitted = false;

    private static final int REQUEST_CODE = 33432;
    private static final int RESULT_CODE = 0x12;
    private static final String TYPE_STRING_APK = "application/vnd.android.package-archive";

    public static void registerWith(Registrar registrar) {
        OpenFilePlugin plugin = new OpenFilePlugin();
        plugin.activity = registrar.activity();
        plugin.context = registrar.context();
        plugin.channel = new MethodChannel(registrar.messenger(), "open_file");
        plugin.channel.setMethodCallHandler(plugin);
        registrar.addRequestPermissionsResultListener(plugin);
        registrar.addActivityResultListener(plugin);
    }


    private boolean hasPermission(String permission) {
        return ContextCompat.checkSelfPermission(activity, permission) == PermissionChecker.PERMISSION_GRANTED;
    }

    @Override
    @SuppressLint("NewApi")
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        isResultSubmitted = false;
        if (call.method.equals("open_file")) {
            filePath = call.argument("file_path");
            this.result = result;

            if (call.hasArgument("type") && call.argument("type") != null) {
                typeString = call.argument("type");
            } else {
                typeString = getFileType(filePath);
            }
            if (pathRequiresPermission()) {
                if (hasPermission(Manifest.permission.READ_EXTERNAL_STORAGE)) {
                    if (TYPE_STRING_APK.equals(typeString)) {
                        openApkFile();
                        return;
                    }
                    startActivity();
                } else {
                    ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, REQUEST_CODE);
                }
            } else {
                startActivity();
            }
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
            String appDirCanonicalPath = new File(context.getApplicationInfo().dataDir).getCanonicalPath();
            String fileCanonicalPath = new File(filePath).getCanonicalPath();
            return !fileCanonicalPath.startsWith(appDirCanonicalPath);
        } catch (IOException e) {
            e.printStackTrace();
            return true;
        }
    }


    private void startActivity() {
        if (filePath == null) {
            return;
        }
        File file = new File(filePath);
        if (!file.exists()) {
            result(-2, "the " + filePath + " file does not exists");
            return;
        }

        Intent intent = new Intent(Intent.ACTION_VIEW);
        if(TYPE_STRING_APK.equals(typeString))
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        else
            intent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        intent.addCategory("android.intent.category.DEFAULT");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            String packageName = context.getPackageName();
            Uri uri = FileProvider.getUriForFile(context, packageName + ".fileProvider.com.crazecoder.openfile", new File(filePath));
            intent.setDataAndType(uri, typeString);
        } else {
            intent.setDataAndType(Uri.fromFile(file), typeString);
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


    private String getFileType(String filePath) {
        String[] fileStrs = filePath.split("\\.");
        String fileTypeStr = fileStrs[fileStrs.length - 1].toLowerCase();
        switch (fileTypeStr) {
            case "3gp":
                return "video/3gpp";
            case "apk":
                return TYPE_STRING_APK;
            case "asf":
                return "video/x-ms-asf";
            case "avi":
                return "video/x-msvideo";
            case "bin":
                return "application/octet-stream";
            case "bmp":
                return "image/bmp";
            case "c":
                return "text/plain";
            case "class":
                return "application/octet-stream";
            case "conf":
                return "text/plain";
            case "cpp":
                return "text/plain";
            case "doc":
                return "application/msword";
            case "docx":
                return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            case "xls":
                return "application/vnd.ms-excel";
            case "xlsx":
                return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            case "exe":
                return "application/octet-stream";
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
                return "application/x-javaScript";
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

    @RequiresApi(api = Build.VERSION_CODES.M)
    private void openApkFile() {
        if (!canInstallApk()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startInstallPermissionSettingActivity();
            } else {
                ActivityCompat.requestPermissions(activity,
                        new String[]{Manifest.permission.REQUEST_INSTALL_PACKAGES}, REQUEST_CODE);
            }
        } else {
            startActivity();
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    private boolean canInstallApk() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            return activity.getPackageManager().canRequestPackageInstalls();
        }
        return hasPermission(Manifest.permission.REQUEST_INSTALL_PACKAGES);
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void startInstallPermissionSettingActivity() {
        if (activity == null) {
            return;
        }
        Uri packageURI = Uri.parse("package:" + activity.getPackageName());
        Intent intent = new Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES, packageURI);
        activity.startActivityForResult(intent, RESULT_CODE);
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] strings, int[] grantResults) {
        if (requestCode != REQUEST_CODE) return false;
        if (hasPermission(Manifest.permission.READ_EXTERNAL_STORAGE)
                && TYPE_STRING_APK.equals(typeString)) {
            openApkFile();
            return false;
        }
        for (int i = 0; i < strings.length; i++) {
            if (!hasPermission(strings[i])) {
                result(-3, "Permission denied: " + strings[i]);
                return false;
            }
        }
        startActivity();
        return true;
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == RESULT_CODE) {
            if (canInstallApk()) {
                startActivity();
                result(0, "done");
            } else {
                result(-3, "Permission denied: " + Manifest.permission.REQUEST_INSTALL_PACKAGES);
            }
        }
        return false;
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
        binding.addRequestPermissionsResultListener(this);
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        if (channel == null) {
            // Could be on too low of an SDK to have started listening originally.
            return;
        }

        channel.setMethodCallHandler(null);
        channel = null;
    }
}
