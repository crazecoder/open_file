import 'dart:async';

import 'package:open_file_plus/src/common/open_result.dart';

import 'web.dart' as web;

class OpenFile {
  OpenFile._();

  static Future<OpenResult> open(
    String? filePath, {
    String? type,
    String? uti,
    String linuxDesktopName = "xdg",
    bool linuxByProcess = false,
  }) async {
    final b = await web.open("file://$filePath");
    return OpenResult(
      type: b ? ResultType.done : ResultType.error,
      message: b ? "done" : "there are some errors when open $filePath",
    );
  }
}
