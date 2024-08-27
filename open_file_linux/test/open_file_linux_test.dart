import 'package:flutter_test/flutter_test.dart';
import 'package:open_file_linux/open_file_linux.dart';

void main() {
  group("openFile", (){
    test('open file on linux when filePath is empty', ()async {
      await OpenFileLinux().open("");
    });
  });

}