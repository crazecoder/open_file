import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_file_platform_interface/open_file_platform_interface.dart';

const MethodChannel _channel = MethodChannel('open_file');

/// An MacOS implementation of [OpenFilePlatform].
class OpenFileMac extends OpenFilePlatform {
  static void registerWith() {
    OpenFilePlatform.platform = OpenFileMac();
  }

  /// The MethodChannel that is being used by this implementation of the plugin.
  @visibleForTesting
  MethodChannel get channel => _channel;

  @override
  Future<OpenResult> open(
    String? filePath, {
    String? type,
    bool isIOSAppOpen = false,
    String linuxDesktopName = "xdg",
    bool linuxUseGio = false,
    bool linuxByProcess = false,
  }) async {
    assert(filePath != null);
    Map<String, String?> map = {
      "file_path": filePath!,
      "type": type,
    };
    final result = await _channel.invokeMethod('open_file', map);
    final resultMap = json.decode(result) as Map<String, dynamic>;
    return OpenResult.fromJson(resultMap);
  }
}
