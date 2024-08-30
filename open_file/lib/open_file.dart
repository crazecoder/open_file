import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:open_file_platform_interface/open_file_platform_interface.dart';

/// Provides an easy way to open file from the library,
class OpenFile {
  OpenFile._();

  /// The platform interface that drives this plugin
  @visibleForTesting
  static OpenFilePlatform get platform => OpenFilePlatform.platform;

  ///Returns a [OpenResult] object wrapping the error message if it has occurred.
  ///if user has already opened the file, returns [ResultType.done]
  ///In linux, you must specify a parameter that tells the application whether to open using [linuxUseGio] or [linuxByProcess]
  static Future<OpenResult> open(
    String? filePath, {
    String? type,
    bool isIOSAppOpen = false,
    String linuxDesktopName = "xdg",
    bool linuxUseGio = false,
    bool linuxByProcess = true,
  }) async {
    return OpenFilePlatform.platform.open(
      filePath,
      type: type,
      isIOSAppOpen: isIOSAppOpen,
      linuxDesktopName: linuxDesktopName,
      linuxUseGio: linuxUseGio,
      linuxByProcess: linuxByProcess,
    );
  }
}
