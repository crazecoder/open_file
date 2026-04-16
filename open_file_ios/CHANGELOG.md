## 1.0.5
* Add UISceneDelegate support for compatibility with Flutter 3.38+ and iOS 26+.
  Uses `FlutterPluginRegistrar.viewController` to obtain the root view controller,
  eliminating reliance on deprecated `UIApplication.windows` enumeration.
  Falls back to `UIWindowScene.keyWindow` (iOS 15+) or window iteration (iOS 13–14).

## 1.0.4
* Fix compatibility with UIScene.
## 1.0.3
* update `open_file_platform_interface: ^1.0.3`.
## 1.0.2
* add `isIOSAppOpen` Whether to use the app to open.
* The objc code is optimized
## 1.0.1
* replace ```presentOpenInMenuFromRect``` with ```presentViewController``` and a return is added.
* The objc code is optimized
## 1.0.0
* TODO: Describe initial release.
