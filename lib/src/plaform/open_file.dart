import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/src/common/open_result.dart';
import 'macos.dart' as mac;
import 'windows.dart' as windows;
import 'linux.dart' as linux;

class OpenFile {
  static const MethodChannel _channel = const MethodChannel('open_file');

  OpenFile._();

  ///linuxDesktopName like 'xdg'/'gnome'
  static Future<OpenResult> open(String filePath,
      {String? type, String? uti, String linuxDesktopName = "xdg", bool linuxByProcess = false}) async {
    if (!Platform.isIOS && !Platform.isAndroid) {
      int _result;
      if (Platform.isMacOS) {
        _result = mac.system('open $filePath');
      } else if (Platform.isLinux) {
        if (linuxByProcess) {
          _result = Process.runSync('xdg-open', [filePath]).exitCode;
        } else {
          _result = linux.system('$linuxDesktopName-open "$filePath"');
        }
      } else {
        _result = windows.shellExecute('open', filePath);
      }
      return OpenResult(
          type: _result == 0 ? ResultType.done : ResultType.error,
          message: _result == 0
              ? "done"
              : "there are some errors when open $filePath");
    }

    Map<String, String?> map = {
      "file_path": filePath,
      "type": type,
      "uti": uti,
    };
    final _result = await _channel.invokeMethod('open_file', map);
    final resultMap = json.decode(_result) as Map<String, dynamic>;
    return OpenResult.fromJson(resultMap);
  }
}
