import 'dart:async';
import 'web.dart' as web;

class OpenFile {
  static Future<String> open(String filePath) async {
    bool _b = await web.open("file://$filePath");
    return _b ? "done" : "there are some errors when open $filePath";
  }
}
