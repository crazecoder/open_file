import 'dart:async';

import 'package:flutter/services.dart';

class OpenFile {
  static const MethodChannel _channel = const MethodChannel('open_file');

  static Future<String> open(filePath, {String type,String uti}) async {
    Map<String, String> map = {"file_path": filePath, "type": type,"uti":uti};
    return await _channel.invokeMethod('open_file', map);
  }
}
