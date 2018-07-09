import 'dart:async';

import 'package:flutter/services.dart';

class OpenFile {
  static const MethodChannel _channel =
      const MethodChannel('open_file');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static Future<Null> open(filePath) async {
    Map<String, String> map = {"file_path": filePath};
    await _channel.invokeMethod('open_file', map);
  }
}
