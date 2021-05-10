import 'dart:async';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

Future<bool> open(String uri) async {
  return window
      .resolveLocalFileSystemUrl(uri)
      .then((_) => true)
      .catchError((e) => false);
}
