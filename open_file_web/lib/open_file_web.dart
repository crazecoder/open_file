import 'dart:async';
import 'package:web/web.dart' as web;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:open_file_platform_interface/open_file_platform_interface.dart';

/// The web implementation of [OpenFilePlatform].
///
/// This class implements the `package:open_file` functionality for the web.
class OpenFilePlugin extends OpenFilePlatform {
  /// Registers this class as the default instance of [OpenFilePlatform].
  static void registerWith(Registrar registrar) {
    OpenFilePlatform.platform = OpenFilePlugin();
  }

  ///Only files in the web project directory are supported
  @override
  Future<OpenResult> open(
    String? filePath, {
    String? type,
    bool isIOSAppOpen = false,
    String linuxDesktopName = "xdg",
    bool linuxUseGio = false,
    bool linuxByProcess = false,
  }) async {
    if (filePath?.isNotEmpty == true) {
      final window = web.window;

      final windowBase = window.open(filePath!, "");
      return OpenResult(
          type: (windowBase?.opener == window)
              ? ResultType.done
              : ResultType.error,
          message: (windowBase?.opener == window)
              ? "done"
              : "there are some errors when open $filePath");
    } else {
      return OpenResult(
          type: ResultType.error,
          message: "filePath and webData can not be null or empty");
    }
  }
}
