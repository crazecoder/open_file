import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_file_ios/open_file_ios.dart';
import 'package:open_file_platform_interface/src/platform_interface/open_file_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final OpenFileIOS openFile = OpenFileIOS();
  final List<MethodCall> log = <MethodCall>[];
  dynamic returnValue = '';

  setUp(() {
    returnValue = '';
    _ambiguate(TestDefaultBinaryMessengerBinding.instance)!
        .defaultBinaryMessenger
        .setMockMethodCallHandler(openFile.channel,
            (MethodCall methodCall) async {
          log.add(methodCall);
          return returnValue;
        });
    log.clear();
  });

  test('registers instance', () async {
    OpenFileIOS.registerWith();
    expect(OpenFilePlatform.platform, isA<OpenFileIOS>());
  });


  test('open', () async {
    expect(await openFile.open(null), throwsArgumentError);
  });
}
/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` on the stable branch.
T? _ambiguate<T>(T? value) => value;