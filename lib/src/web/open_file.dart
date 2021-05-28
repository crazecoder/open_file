import 'dart:async';
import 'package:open_file/src/common/open_result.dart';

import 'web.dart' as web;

class OpenFile {
  OpenFile._();
  static Future<OpenResult> open(String? filePath,
      {String? type,
        String? uti,
        String linuxDesktopName = "xdg",
        bool linuxByProcess = false}) async {
    final _b = await web.open("file://$filePath");
    return OpenResult(
        type: _b ? ResultType.done : ResultType.error,
        message: _b ? "done" : "there are some errors when open $filePath");
  }
}
