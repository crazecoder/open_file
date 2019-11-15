import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'macos.dart' as mac;
import 'linux.dart' as linux;
import 'windows.dart' as windows;

class OpenFile {
  static const MethodChannel _channel = const MethodChannel('open_file');

  ///linuxDesktopName like 'xdg'/'gnome'
  static Future<String> open(String filePath,
      {String type, String uti, String linuxDesktopName = "xdg"}) async {
    if (!Platform.isIOS && !Platform.isAndroid) {
      int _result;
      if (Platform.isMacOS) {
        _result = mac.system('open $filePath');
      } else if (Platform.isLinux) {
        _result = linux.system(
            '$linuxDesktopName-open $filePath');
      }else{
        _result = windows.ShellExecute('open',filePath);
      }
      return _result == 0
          ? "done"
          : "there are some errors when open $filePath";
    }

    Map<String, String> map = {"file_path": filePath, "type": type, "uti": uti};
    return await _channel.invokeMethod('open_file', map);
  }
}
