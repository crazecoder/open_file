import 'package:flutter/material.dart';
import 'dart:async';

import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _openResult = 'Unknown';

  Future<void> openFile() async {
    Dio dio = Dio();
    final filePath = '/sdcard/Download/test';
    // final filePath = '/Users/chendong/Downloads/S91010-16435053-221705-o_1dmqeua2a2v2o0u126l1baqqc21e-uid-1817947@1080x2160.jpg';
    // await dio.download("https://imgsa.baidu.com/exp/w=500/sign=9d6f3ebe35d3d539c13d0fc30a86e927/7aec54e736d12f2eedbdb0204cc2d56285356831.jpg", filePath);

    final result = await OpenFile.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });

  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('open result: $_openResult\n'),
              FlatButton(
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