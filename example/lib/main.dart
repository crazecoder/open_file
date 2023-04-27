import 'package:flutter/material.dart';
import 'dart:async';

import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _openResult = 'Unknown';

  Future<void> openFile() async {
    _openAppPrivateFile();
  }

  _openAppPrivateFile() async {
    //open an app private storage file
    final result = await OpenFile.open(
        "/sdcard/Android/data/com.crazecoder.openfileexample/R-C.jpeg");
    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });
  }

  // ignore: unused_element
  _openExternalImage() async {
    //open an external storage image file on android 13
    if (await Permission.photos.request().isGranted) {
      final result = await OpenFile.open("/sdcard/Download/R-C.jpeg");
      setState(() {
        _openResult = "type=${result.type}  message=${result.message}";
      });
    }
  }

  // ignore: unused_element
  _openExternalVideo() async {
    //open an external storage video file on android 13
    if (await Permission.videos.request().isGranted) {
      final result = await OpenFile.open("/sdcard/Download/R-C.mp4");
      setState(() {
        _openResult = "type=${result.type}  message=${result.message}";
      });
    }
  }

  // ignore: unused_element
  _openExternalAudio() async {
    //open an external storage audio file on android 13
    if (await Permission.audio.request().isGranted) {
      final result = await OpenFile.open("/sdcard/Download/R-C.mp3");
      setState(() {
        _openResult = "type=${result.type}  message=${result.message}";
      });
    }
  }

  // ignore: unused_element
  _openExternalFile() async {
    //open an external storage file
    if (await Permission.manageExternalStorage.request().isGranted) {
      final result = await OpenFile.open("/sdcard/Android/data/R-C.xml");
      setState(() {
        _openResult = "type=${result.type}  message=${result.message}";
      });
    }
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
                onPressed: openFile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
