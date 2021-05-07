import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:open_file/src/common/parse_args.dart';

typedef SystemC = ffi.Int32 Function(ffi.Pointer<Utf8> command);

typedef SystemDart = int Function(ffi.Pointer<Utf8> command);

int system(List<String> args) {
  // Load `stdlib`. On MacOS this is in libSystem.dylib.
  final dylib = ffi.DynamicLibrary.open('/usr/lib/libSystem.dylib');

  // Look up the `system` function.
  final systemP = dylib.lookupFunction<SystemC, SystemDart>('system');

  // Allocate a pointer to a Utf8 array containing our command.
  final cmdP = parseArgs(args).toNativeUtf8();

  // Invoke the command, and free the pointer.
  final result = systemP(cmdP);
  calloc.free(cmdP);

  return result;
}
