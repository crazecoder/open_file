import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:open_file_platform_interface/open_file_platform_interface.dart';

import 'open_file_test.mocks.dart';

@GenerateMocks([OpenFilePlatform])
void main() {
  group('OpenFile', () {
    late MockOpenFilePlatform mockFileOpener;

    setUp(() {
      mockFileOpener = MockOpenFilePlatform();
    });

    test('returns success OpenResult', () async {
      const filePath = '/example/file.txt';
      final expectedResult = OpenResult(
        type: ResultType.done,
        message: 'Opened successfully',
      );

      when(mockFileOpener.open(filePath))
          .thenAnswer((_) async => expectedResult);

      final result = await mockFileOpener.open(filePath);

      expect(result.type, ResultType.done);
      expect(result.message, 'Opened successfully');
      verify(mockFileOpener.open(filePath)).called(1);
    });
  });
}