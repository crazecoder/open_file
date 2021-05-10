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
