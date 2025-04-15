import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file_mac/open_file_mac.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _openResult = 'Unknown';

  Future<void> _openPickFile() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
    if (fileResult?.files.first != null) {
      final result = await OpenFileMac().open(fileResult!.files.first.path);
      setState(() {
        _openResult = "type=${result.type}  message=${result.message}";
      });
    }
  }

  Future<void> openFile() async {
    final result =
        await OpenFileMac().open("/Users/chendong/Downloads/R-C.jpeg");
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
              TextButton(
                child: Text('Tap to open file'),
                onPressed: _openPickFile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
