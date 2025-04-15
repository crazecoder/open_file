import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file_ios/open_file_ios.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _openResult = 'Unknown';
  bool canRequestFocus = true;

  Future<void> openFile() async {
    _openExternalImage();
  }

  // ignore: unused_element
  _openPickFile() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
    if (fileResult?.files.first != null) {
      final result = await OpenFileIOS().open(fileResult!.files.first.path);
      setState(() {
        _openResult = "type=${result.type}  message=${result.message}";
      });
    }
  }

  _openExternalImage() async {
    setState(() {
      canRequestFocus = false;
    });
    final result = await OpenFileIOS().open(
        "/Users/crazecoder/Library/Developer/CoreSimulator/Devices/9FDE8459-AD12-4665-A0C0-FF1A5D82CF9D/data/Downloads/1.jpeg",
        isIOSAppOpen: true);
    // final result = await OpenFileIOS().open("/Users/crazecoder/Library/Developer/CoreSimulator/Devices/9FDE8459-AD12-4665-A0C0-FF1A5D82CF9D/data/Downloads/R-C.jpeg");
    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
      canRequestFocus = true;
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
              TextField(
                autofocus: false,
                canRequestFocus: canRequestFocus,
              ),
              TextButton(
                onPressed: openFile,
                child: const Text('Tap to open file'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
