import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

typedef SystemC = ffi.Int32 Function(ffi.Pointer<Utf8> command);

typedef SystemDart = int Function(ffi.Pointer<Utf8> command);

int system(String command) {
  // Load `stdlib`. On MacOS this is in libSystem.dylib.
  final dylib = ffi.DynamicLibrary.open('libc.so.6');

  // Look up the `system` function.
  final systemP = dylib.lookupFunction<SystemC, SystemDart>('system');

  // Allocate a pointer to a Utf8 array containing our command.
  final cmdP = command.toNativeUtf8();

  // Invoke the command, and free the pointer.
  int result = systemP(cmdP);
//  cmdP.free();

  return result;
}
