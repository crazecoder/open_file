import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _openResult = 'Unknown';

  Future<String> get _tempPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<File> getTempFile({required String fileName, String fileType = "pdf"}) async {
    final path = await _tempPath;
    return File('$path/$fileName.$fileType');
  }

  Future<File> writeFileFromBytes({required String fileName, String fileType = "pdf", required Uint8List fileContent}) async {
    File file = await getTempFile(fileName: fileName, fileType: fileType);
    file.writeAsBytes(fileContent);
    return file;
  }

  Future<String?> generatePdf() async{

    pdfWidget.Document pdfDocument = pdfWidget.Document();

    pdfDocument.addPage(
        pdfWidget.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pdfWidget.EdgeInsets.all(20.0),
            build: (pdfWidget.Context context) {
              return pdfWidget.Center(
                child: pdfWidget.Text("This is a beautiful PDF"),
              );
            }
        )
    );

    // Sauvegarde le PDF
    File file = await writeFileFromBytes(
        fileName: "temp",
        fileType: "pdf",
        fileContent: await pdfDocument.document.save());
    return file.path;
  }

  Future<void> openFile() async {

    String? filePath = await generatePdf();
    final message = await OpenFile.open(filePath);

    setState(() {
      _openResult = "message=$message";
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
                onPressed: openFile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
