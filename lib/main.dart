import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImageProcesser(title: 'AI IMAGE PROCESSOR'),
    );
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

  void _processImage() async {
    late Future<http.Response> processedImage =
        uploadImage(File(_selectedImage!.path));
    // ignore: avoid_print
    print(processedImage);
  }

  Future<http.Response> uploadImage(File image) async {
    String base64Image = base64Encode(image.readAsBytesSync());
    String fileName = image.path.split("/").last;

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5001/api/image-process'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "image": base64Image,
        "name": fileName,
      }),
    );

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
                  )
                ],
              ),
      ),
    );
  }
}


// FutureBuilder<Album>(
//   future: _futureAlbum,
//   builder: (context, snapshot) {
//     if (snapshot.hasData) {
//       return Text(snapshot.data!.title);
//     } else if (snapshot.hasError) {
//       return Text('${snapshot.error}');
//     }

//     return const CircularProgressIndicator();
//   },
// )