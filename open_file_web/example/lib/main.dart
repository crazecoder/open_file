import 'package:flutter/material.dart';
import 'package:open_file_web/open_file_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _openFile = OpenFilePlugin();
  String _result = "click to open file";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(child: Text(_result),onTap: ()async{
            final resultType = await _openFile.open("./icons/Icon-192.png");

            setState(() {
              _result = resultType.message;
            });
          },),
        ),
      ),
    );
  }
}
