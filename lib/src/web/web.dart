import 'dart:async';
import 'dart:html';

Future<bool> open(String uri) async {
  try {
    Entry _e = await window.resolveLocalFileSystemUrl(uri);
    return _e != null;
  } catch (e) {
    print(e);
    return false;
  }
}
