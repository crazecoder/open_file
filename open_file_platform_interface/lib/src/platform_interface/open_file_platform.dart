import 'dart:async';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../types/open_result.dart';

abstract class OpenFilePlatform extends PlatformInterface {
  static final Object _token = Object();
  static late OpenFilePlatform _instance;

  static OpenFilePlatform get platform => _instance;

  OpenFilePlatform() : super(token: _token);

  static set platform(OpenFilePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<OpenResult> open(
    String? filePath, {
    String? type,
    bool isIOSAppOpen = false,
    String linuxDesktopName = "xdg",
    bool linuxUseGio = false,
    bool linuxByProcess = false,
  }) async {
    throw UnimplementedError('open() has not been implemented.');
  }
}
