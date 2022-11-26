import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

const _androidCacheDir = '/data/data/com.crazecoder.openfileexample/cache';
const _windowInfoFilePath = '$_androidCacheDir/window-info.txt';

const filePaths = [
  '/storage/emulated/0/update.apk',
  _windowInfoFilePath,
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && Platform.isAndroid && await Directory(_androidCacheDir).exists()) {
    final window = WidgetsBinding.instance.window;
    await File(_windowInfoFilePath).writeAsString(//
        'window:\n'
        'physicalSize: ${window.physicalSize}\n'
        'devicePixelRatio: ${window.devicePixelRatio}\n'
        'viewPadding: ${window.viewPadding}\n'
        'viewInsets: ${window.viewInsets}\n'
        'locales: ${window.locales}\n'
        'displayFeatures: ${window.displayFeatures}\n'
        '\n');
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _openResult = 'Unknown';

  Future<void> openFile(String filePath) async {
    final result = await OpenFile.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('open result: $_openResult\n'),
              for (final filePath in filePaths)
                TextButton(
                  child: Text(
                    'open: $filePath',
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                  onPressed: () => openFile(filePath),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
