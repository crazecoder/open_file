## 3.5.7
* fix [#300](https://github.com/crazecoder/open_file/issues/300)
## 3.5.6
* fix [#298](https://github.com/crazecoder/open_file/issues/298)
## 3.5.5
fix for wasm (thanks to [@sgehrman](https://github.com/sgehrman))
## 3.5.4
* fix [#294](https://github.com/crazecoder/open_file/issues/294)
## 3.5.3
* remove `uti`, DocumentInteraction Auto on iOS.
* remove `webData`, only open files in the project directory on the web
* add `isIOSAppOpen` Whether to use the app to open on iOS.
## 3.5.2
* update ```open_file_ios: ^1.0.1```
  replace presentOpenInMenuFromRect with presentViewController
* update ```open_file_android: ^1.0.1``` to fix [#245](https://github.com/crazecoder/open_file/issues/245)
## 3.5.1
* update ```open_file_linux: ^0.0.3``` to fix [#291](https://github.com/crazecoder/open_file/issues/291)
## 3.5.0+1
* linuxByProcess defaults to true [#156](https://github.com/crazecoder/open_file/pull/156)
## 3.5.0
* Utilize the new platform_interface package.
* Updates minimum Flutter version to 1.20.0.
* add @visibleForTesting to some methods
* fix [#289](https://github.com/crazecoder/open_file/issues/289)
## 3.4.0
* Optimized the logical judgment of permission requests for each android version
* update `ffi` to 2.1.3
* AGP 8 namespace issue fix (thanks to [@prataptej](https://github.com/prataptej))
* add linuxUseGio parameter (thanks to [@brainwo](https://github.com/brainwo))
## 3.3.2
* Optimized the logic for determining the cache/files directory for android applications
* add a conditional judgment for `PackageManager.queryIntentActivities`
* update `ffi` to 2.0.2
## 3.3.1
* Refine the media permissions for Android13
* Add an [example](https://github.com/crazecoder/open_file/blob/master/example/lib/main.dart) of full use
## 3.3.0
* Remove the code of permission on Android, If you want to open an external file, You need to request permission
## 3.2.2
* `FFi` updated to v2.
* android migrated from `v1` to `v2`,
* folder name corrected, ` plaform -> platform`.
* package version updated to `3.2.2`
* Gradle updated to `gradle-7.3.1`
## 3.2.1
* Add command parser before create system call [#144](https://github.com/crazecoder/open_file/issues/144) (thanks to [@mludovico](https://github.com/mludovico))
* Fix startActivity() might have NPE issue with filePath on Android (thanks to [@AlexV525](https://github.com/AlexV525))
* Add error type return when file path is nil on iOS
## 3.2.0
* add csv/kml/gpx/torrent support on Android
* remove android:requestLegacyExternalStorage
* fix Deprecated API warning when build on Android
* delete uti, DocumentInteraction will be retrieved automatically on iOS (thanks to [@std-c](https://github.com/std-c))
* fix returns wrong reponse on Windows
## 3.1.0
* upgrade FFI 1.0.0 (thanks to [@mit-mit](https://github.com/mit-mit))
* add linuxByProcess parameter (thanks to [@mx1up](https://github.com/mx1up))
* Migrate to Dart null safety system (thanks to [@orevial](https://github.com/orevial))
## 3.0.3
* upgrade compileSdkVersion
## 3.0.2
* add storage compatibility mode for AndroidQ.
* fix [#106](https://github.com/crazecoder/open_file/issues/106) [#100](https://github.com/crazecoder/open_file/issues/100) [#74](https://github.com/crazecoder/open_file/issues/74)
* fix multiple file providers. (thanks to [@jawa0919](https://github.com/jawa0919))
* Take file extension in lowercase for comparison.(thanks to [@kluverua](https://github.com/kluverua))
* Fixed a typo in the error message for fileNotFound.(thanks to [@sebas642](https://github.com/sebas642))
## 3.0.1
* fix web parameter error
* Replace result value from String to OpenResult.
## 3.0.0
* updated to the v2 Android Plugin APIs
* Distinguish android errors (No APP found and others)
* add web support
* add pc support
## 2.1.1
* rollback 2.0.3
## 2.1.0-pre.1
* add web support(beta)
* add pc support(beta)
## 2.0.3
* change use FileProvider from Android M to Android N
## 2.0.2
* catch No Activity found to handle Intent exception
* Optimize request REQUEST_INSTALL_PACKAGES permission on Android O
## 2.0.1+2
* fix android M FLAG_GRANT_READ_URI_PERMISSION
## 2.0.1+1
* Fixed crash caused by third party plug-in request permissions
## 2.0.1
* migrate to androidx
## 1.3.0
* roll back support
## 1.2.3+1
* request READ_EXTERNAL_STORAGE when the file is not in the app directory
## 1.2.3
* Optimize permission request logic on android
## 1.2.2+2
* fix crash when requestPermission
## 1.2.2+1
* migrate to androidx
## 1.2.2
* ask for permission when needed
## 1.2.1
* fix somethings
## 1.2.0
* Add custom parameters,"type" android,"uti" iOS
## 1.1.1
* fix startActivity crash in android
## 1.1.0
* fix ios open file
## 1.0.7
* resolve conflict with other plugins about FileProvider and multi appcompat-v7 compile
## 1.0.6
* resolve conflict with image_provider plugin
## 1.0.5
* Just Support >=2.0.0-dev.28.0
## 1.0.4
* Just Support Dart2
## 1.0.3
* Just Support Dart2
## 1.0.2
* Ios Support added and support android 7.0 or above
