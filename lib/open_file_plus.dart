library open_file_plus;

export 'src/common/open_result.dart';
export 'src/platform/open_file.dart' if (dart.library.html) 'src/web/open_file.dart';
