# open_file
[![pub package](https://img.shields.io/pub/v/open_file.svg)](https://pub.dartlang.org/packages/open_file)

A plug-in that can call native APP to open files with string result in flutter, support iOS(DocumentInteraction) / android(intent) / PC(ffi) / web(dart:html)

## Usage

To use this plugin, add [open_file](https://pub.dartlang.org/packages/open_file#-installing-tab-) as a dependency in your pubspec.yaml file.
```yaml
dependencies:
  #androidx
  open_file: ^lastVersion 
  #support
  #open_file: ^1.3.0
```

## Example
```dart
import 'package:open_file/open_file.dart';

OpenFile.open("/sdcard/example.txt");
//OpenFile.open("/sdcard/example.txt", type: "text/plain", uti: "public.plain-text");
```

## Support
### android
```
{
            {".3gp",    "video/3gpp"},
            {".torrent","application/x-bittorrent"},
            {".kml",    "application/vnd.google-earth.kml+xml"},
            {".gpx",    "application/gpx+xml"},
            {".csv",    "application/vnd.ms-excel"},
            {".apk",    "application/vnd.android.package-archive"},
            {".asf",    "video/x-ms-asf"},
            {".avi",    "video/x-msvideo"},
            {".bin",    "application/octet-stream"},
            {".bmp",    "image/bmp"},
            {".c",      "text/plain"},
            {".class",  "application/octet-stream"},
            {".conf",   "text/plain"},
            {".cpp",    "text/plain"},
            {".doc",    "application/msword"},
            {".docx",   "application/vnd.openxmlformats-officedocument.wordprocessingml.document"},
            {".xls",    "application/vnd.ms-excel"},
            {".xlsx",   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"},
            {".exe",    "application/octet-stream"},
            {".gif",    "image/gif"},
            {".gtar",   "application/x-gtar"},
            {".gz",     "application/x-gzip"},
            {".h",      "text/plain"},
            {".htm",    "text/html"},
            {".html",   "text/html"},
            {".jar",    "application/java-archive"},
            {".java",   "text/plain"},
            {".jpeg",   "image/jpeg"},
            {".jpg",    "image/jpeg"},
            {".js",     "application/x-javascript"},
            {".log",    "text/plain"},
            {".m3u",    "audio/x-mpegurl"},
            {".m4a",    "audio/mp4a-latm"},
            {".m4b",    "audio/mp4a-latm"},
            {".m4p",    "audio/mp4a-latm"},
            {".m4u",    "video/vnd.mpegurl"},
            {".m4v",    "video/x-m4v"},
            {".mov",    "video/quicktime"},
            {".mp2",    "audio/x-mpeg"},
            {".mp3",    "audio/x-mpeg"},
            {".mp4",    "video/mp4"},
            {".mpc",    "application/vnd.mpohun.certificate"},
            {".mpe",    "video/mpeg"},
            {".mpeg",   "video/mpeg"},
            {".mpg",    "video/mpeg"},
            {".mpg4",   "video/mp4"},
            {".mpga",   "audio/mpeg"},
            {".msg",    "application/vnd.ms-outlook"},
            {".ogg",    "audio/ogg"},
            {".pdf",    "application/pdf"},
            {".png",    "image/png"},
            {".pps",    "application/vnd.ms-powerpoint"},
            {".ppt",    "application/vnd.ms-powerpoint"},
            {".pptx",   "application/vnd.openxmlformats-officedocument.presentationml.presentation"},
            {".prop",   "text/plain"},
            {".rc",     "text/plain"},
            {".rmvb",   "audio/x-pn-realaudio"},
            {".rtf",    "application/rtf"},
            {".sh",     "text/plain"},
            {".tar",    "application/x-tar"},
            {".tgz",    "application/x-compressed"},
            {".txt",    "text/plain"},
            {".wav",    "audio/x-wav"},
            {".wma",    "audio/x-ms-wma"},
            {".wmv",    "audio/x-ms-wmv"},
            {".wps",    "application/vnd.ms-works"},
            {".xml",    "text/plain"},
            {".z",      "application/x-compress"},
            {".zip",    "application/x-zip-compressed"},
            {"",        "*/*"}
}

```
when Conflict with other plugins about FileProvider, add code below in your `/android/app/src/main/AndroidManifest.xml`
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools"
          package="xxx.xxx.xxxxx">
    <application>
        ...
        <provider
                android:name="androidx.core.content.FileProvider"
                android:authorities="${applicationId}.fileProvider"
                android:exported="false"
                android:grantUriPermissions="true"
                tools:replace="android:authorities">
            <meta-data
                    android:name="android.support.FILE_PROVIDER_PATHS"
                    android:resource="@xml/filepaths"
                    tools:replace="android:resource" />
        </provider>
    </application>
</manifest>
```
furthermore add code below in your `/android/app/src/main/res/xml/filepaths.xml`
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <external-path name="external_storage_directory" path="." />
</resources>
```

when Android dependency 'com.android.support:appcompat-v7' has different version for the compile error, add code below in your /android/build.gradle
```gradle
subprojects {
    project.configurations.all {
        resolutionStrategy.eachDependency { details ->
            if (details.requested.group == 'com.android.support'
                    && !details.requested.name.contains('multidex') ) {
                details.useVersion "27.1.1"
            }
        }
    }
}
```


### IOS with UTI (DocumentInteraction Auto)
```
{
            {".rtf",    "public.rtf"},
            {".txt",    "public.plain-text"},
            {".html",   "public.html"},
            {".htm",    "public.html"},
            {".xml",    "public.xml"},
            {".tar",    "public.tar-archive"},
            {".gz",     "org.gnu.gnu-zip-archive"},
            {".gzip",   "org.gnu.gnu-zip-archive"},
            {".tgz",    "org.gnu.gnu-zip-tar-archive"},
            {".jpg",    "public.jpeg"},
            {".jpeg",   "public.jpeg"},
            {".png",    "public.png"},
            {".avi",    "public.avi"},
            {".mpg",    "public.mpeg"},
            {".mpeg",   "public.mpeg"},
            {".mp4",    "public.mpeg-4"},
            {".3gpp",   "public.3gpp"},
            {".3gp",    "public.3gpp"},
            {".mp3",    "public.mp3"},
            {".zip",    "com.pkware.zip-archive"},
            {".gif",    "com.compuserve.gif"},
            {".bmp",    "com.microsoft.bmp"},
            {".ico",    "com.microsoft.ico"},
            {".doc",    "com.microsoft.word.doc"},
            {".xls",    "com.microsoft.excel.xls"},
            {".ppt",    "com.microsoft.powerpoint.​ppt"},
            {".wav",    "com.microsoft.waveform-​audio"},
            {".wm",     "com.microsoft.windows-​media-wm"},
            {".wmv",    "com.microsoft.windows-​media-wmv"},
            {".pdf",    "com.adobe.pdf"}
}
```
