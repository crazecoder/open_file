import 'package:flutter_test/flutter_test.dart';
import 'package:open_file/open_file.dart';
import 'package:open_file_platform_interface/open_file_platform_interface.dart';

void main() {
  group('OpenFile', () {

    setUp(() {
      OpenFilePlatform.platform = OpenFile.platform;
    });
    test('open file from path', () async {
      await OpenFile.open("path");
    });
  });
}
