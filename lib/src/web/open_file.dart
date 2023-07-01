import 'dart:async';
import 'dart:typed_data';
import 'package:open_file/src/common/open_result.dart';

import 'web.dart' as web;

class OpenFile {
  OpenFile._();
  ///[filePath] You need to pass the file name to determine the file type
  static Future<OpenResult> open(String? filePath, 
      {String? type,
      String? uti,
      String linuxDesktopName = "xdg",
      bool linuxByProcess = false,
      Uint8List? webData}) async {
    if (filePath?.isNotEmpty == true && webData?.isNotEmpty == true) {
      final _b = await web.open(filePath, data: webData);
      return OpenResult(
          type: _b ? ResultType.done : ResultType.error,
          message: _b ? "done" : "there are some errors when open $filePath");
    } else {
      return OpenResult(
          type: ResultType.error, message: "filePath and webData can not be null or empty");
    }
  }
}
