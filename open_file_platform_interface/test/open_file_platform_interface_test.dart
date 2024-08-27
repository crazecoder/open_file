import 'package:flutter_test/flutter_test.dart';
import 'package:open_file_platform_interface/src/method_channel/method_channel_open_file.dart';

void main() {
  group("openFile", (){
    final MethodChannelOpenFile openFile = MethodChannelOpenFile();
    test('open file when filePath is empty', ()async {
      await openFile.open("");
    });
  });

}
