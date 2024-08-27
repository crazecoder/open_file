import 'package:flutter_test/flutter_test.dart';
import 'package:open_file_windows/open_file_windows.dart';

void main() {
  group("openFile", (){
    test('open file on windows when filePath is empty', ()async {
      await OpenFileWindows().open("");
    });
  });

}