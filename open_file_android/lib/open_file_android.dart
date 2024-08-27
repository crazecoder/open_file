import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_file_platform_interface/open_file_platform_interface.dart';

final MethodChannel _channel = MethodChannel('open_file');

/// An Android implementation of [OpenFilePlatform].
class OpenFileAndroid extends OpenFilePlatform {
  static void registerWith() {
    OpenFilePlatform.platform = OpenFileAndroid();
  }

  /// The MethodChannel that is being used by this implementation of the plugin.
  @visibleForTesting
  MethodChannel get channel => _channel;

  @override
  Future<OpenResult> open(String? filePath,
      {String? type,
        String? uti,
        String linuxDesktopName = "xdg",
        bool linuxUseGio = false,
        bool linuxByProcess = false,
        Uint8List? webData}) async {
    assert(filePath != null);
    Map<String, String?> map = {
      "file_path": filePath!,
      "type": type,
      "uti": uti,
    };
    final _result = await _channel.invokeMethod('open_file', map);
    final resultMap = json.decode(_result) as Map<String, dynamic>;
    return OpenResult.fromJson(resultMap);
  }
}
