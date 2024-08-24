package com.crazecoder.openfile.utils;

import android.content.Context;
import android.os.Build;
import android.os.Environment;

import androidx.annotation.RequiresApi;

import java.io.File;

public class FileUtil {
    public static String getFileMimeType(String filePath) {
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
                return "application/vnd.android.package-archive";
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

    public static String changeToPathUri(String path) {
        return "content://com.android.externalstorage.documents/document/primary%3AAndroid%2Fdata%2F" + getAuthority(path, true, true);
    }

    public static String changeToUri(String path) {
        return "content://com.android.externalstorage.documents/tree/primary%3AAndroid%2Fdata/document/primary%3AAndroid%2Fdata%2F" + getAuthority(path, false, true);
    }

    public static String getAuthority(String filePath, boolean isParentPath, boolean isUtf8) {
        String path = filePath;
        if (isParentPath) {
            File parent = new File(path).getParentFile();
            if (parent != null) path = parent.getAbsolutePath();

        }
        if (path.endsWith("/")) {
            path = path.substring(0, path.length() - 1);
        }
        String resultPath = path.replace("/storage/emulated/0/", "")
                .replace("Android/data/", "");
        if (isUtf8) {
            resultPath = resultPath.replace("/", "%2F");
        }
        return resultPath;
    }

    public static boolean isOtherAndroidDataDir(Context context, String filePath) {
        return filePath.contains("/Android/data/") && !filePath.contains(context.getPackageName());
    }

    public static boolean isImage(String mimeType) {
        return mimeType.contains("image/");
    }

    public static boolean isVideo(String mimeType) {
        return mimeType.contains("video/");
    }

    public static boolean isAudio(String mimeType) {
        return mimeType.contains("audio/");
    }

    @RequiresApi(api = Build.VERSION_CODES.S)
    public static boolean isExternalStoragePublicMedia(String filePath, String mimeType) {
        return isExternalStoragePublicPath(filePath) && (isImage(mimeType) || isVideo(mimeType) || isAudio(mimeType));
    }

    @RequiresApi(api = Build.VERSION_CODES.S)
    public static boolean isExternalStoragePublicPath(String filePath) {
        boolean isExternalStoragePublicPath = false;
        String[] mediaStorePath = {
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getPath()
                , Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS).getPath()
                , Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).getPath()
                , Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES).getPath()
                , Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_ALARMS).getPath()
                , Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_AUDIOBOOKS).getPath()
                , Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM).getPath()
                , Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC).getPath()
                , Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_NOTIFICATIONS).getPath()
                , Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PODCASTS).getPath()
                , Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_RECORDINGS).getPath()
                , Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_RINGTONES).getPath()
                , Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_SCREENSHOTS).getPath()
        };
        for (String s : mediaStorePath) {
            if (filePath.contains(s)) {
                isExternalStoragePublicPath = true;
                break;
            }
        }
        return isExternalStoragePublicPath;
    }

}
