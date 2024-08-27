import 'package:flutter_test/flutter_test.dart';
import 'package:open_file_web/open_file_web.dart';

void main() {
  group("openFile", (){
    test('open file on web when filePath is empty', ()async {
      await OpenFilePlugin().open("");
    });
  });

}