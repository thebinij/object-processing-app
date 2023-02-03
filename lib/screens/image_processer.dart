import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class ResponseData {
  String status;
  String data;

  ResponseData({required this.status, required this.data});

  factory ResponseData.fromJson(Map<String, dynamic> parsedJson) {
    return ResponseData(status: parsedJson['status'], data: parsedJson['data']);
  }
}

class ImageProcesser extends StatefulWidget {
  const ImageProcesser({super.key, required this.title});

  final String title;

  @override
  State<ImageProcesser> createState() => _ImageProcesserState();
}

class _ImageProcesserState extends State<ImageProcesser> {
  XFile? _selectedImage;
  Future<String>? _ocrText;
  bool processing = false;

  void _selectImage() async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _clearImage() async {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<ResponseData> _processImage() async {
    processing = true;
    Future<http.StreamedResponse>? imageData =
        uploadImage(File(_selectedImage!.path));

    final jsonResponse = json.decode(imageData as String);

    return ResponseData.fromJson(jsonResponse);
  }

  Future<http.StreamedResponse> uploadImage(File image) async {
    // String base64Image = base64Encode(image.readAsBytesSync());
    String fileName = image.path.split("/").last;

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:5001/api/image-process'));
    request.fields['name'] = fileName;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print("Image uploaded");
      return response;
    } else {
      // ignore: avoid_print
      print("Failed to upload image");
      throw Exception('Failed to upload image.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _selectedImage == null
            ? ElevatedButton(
                onPressed: _selectImage,
                child: const Text('Select Image'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  kIsWeb
                      ? Image.network(_selectedImage!.path)
                      : Image.file(
                          File(_selectedImage!.path),
                        ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                        ),
                        onPressed: _processImage,
                        child: const Text('Procces Image'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _clearImage,
                        child: const Text('Clear Image'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  processing
                      ? FutureBuilder<String>(
                          future: _ocrText,
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (kDebugMode) {
                              print(snapshot);
                            }
                            if (snapshot.hasData) {
                              processing = false;
                            } else if (snapshot.hasError) {
                              processing = false;
                            }
                            return const CircularProgressIndicator();
                          },
                        )
                      : const SizedBox(height: 10),
                ],
              ),
      ),
    );
  }
}
