import 'dart:io';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:open_file_platform_interface/open_file_platform_interface.dart';

import 'parse_args.dart';

typedef SystemC = ffi.Int32 Function(ffi.Pointer<Utf8> command);

typedef SystemDart = int Function(ffi.Pointer<Utf8> command);

class OpenFileLinux extends OpenFilePlatform {
  static void registerWith() {
    OpenFilePlatform.platform = OpenFileLinux();
  }

  @override
  Future<OpenResult> open(
    String? filePath, {
    String? type,
    bool isIOSAppOpen = false,
    String linuxDesktopName = "xdg",
    bool linuxUseGio = false,
    bool linuxByProcess = true,
  }) async {
    assert(filePath != null);
    assert(linuxUseGio != true || linuxByProcess != true,
        "can't have both linuxUseGio and linuxByProcess");

    int _result;
    var filePathLinux = Uri.file(filePath!);
    if (linuxUseGio) {
      _result = system(['gio', 'open', filePathLinux.toString()]);
    } else {
      if (linuxByProcess) {
        _result = (await Process.run(
                '$linuxDesktopName-open', [filePathLinux.toString()]))
            .exitCode;
      } else {
        _result = system(['$linuxDesktopName-open', filePathLinux.toString()]);
      }
    }

    return OpenResult(
        type: _result == 0 ? ResultType.done : ResultType.error,
        message: _result == 0
            ? "done"
            : _result == -1
                ? "This operating system is not currently supported"
                : "there are some errors when open $filePath");
  }

  int system(List<String> command) {
    // Load `stdlib`. On Linux this is in libc.so.6.
    final dylib = ffi.DynamicLibrary.open('libc.so.6');

    // Look up the `system` function.
    final systemP = dylib.lookupFunction<SystemC, SystemDart>('system');

    // Allocate a pointer to a Utf8 array containing our command.
    final cmdP = parseArgs(command).toNativeUtf8();

    // Invoke the command, and free the pointer.
    final result = systemP(cmdP);
    calloc.free(cmdP);

    return result;
  }
}
