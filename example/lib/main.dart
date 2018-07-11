import 'package:flutter/material.dart';
import 'dart:async';

import 'package:open_file/open_file.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _openResult = 'Unknown';

  @override
  void initState() {
    super.initState();
    openFile("/sdcard/Download/Translate.apk").then((_result){
      setState(() {
        _openResult = _result;
      });
    });
  }

  Future<String> openFile(filePath)async{
    return await OpenFile.open(filePath);
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new Text('open result: $_openResult\n'),
        ),
      ),
    );
  }
}
