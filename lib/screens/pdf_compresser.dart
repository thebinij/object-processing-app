import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFcompressor extends StatefulWidget {
  const PDFcompressor({super.key});

  @override
  State<PDFcompressor> createState() => _PDFcompressorState();
}

class _PDFcompressorState extends State<PDFcompressor> {
  String? filePath;

  void _selectPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Allow only PDF files to be picked
    );
    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Compress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (filePath != null)
              Expanded(
                child: PDFView(
                  filePath: filePath,
                ),
              )
            else
              ElevatedButton(
                onPressed: _selectPDF,
                child: const Text('Select PDF'),
              ),
          ],
        ),
      ),
    );
  }
}
