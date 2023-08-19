import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:library_assignment/widget/button_widget.dart';
import 'dart:io';

import 'api/firebase_api.dart';

class ImageCropperScreen extends StatefulWidget {
  final File imageFile;

  ImageCropperScreen({required this.imageFile});

  @override
  _ImageCropperScreenState createState() => _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  UploadTask? task;
  late File _croppedFile;

  @override
  void initState() {
    super.initState();
    _croppedFile = widget.imageFile;
  }

  Future<void> _cropImage() async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: _croppedFile.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
    );

    if (croppedFile != null) {
      setState(() {
        _croppedFile = File(croppedFile.path); // Convert CroppedFile to File
      });
    }
  }

  Future uploadFile() async {
    if (_croppedFile == null) return;

    final fileName = (_croppedFile!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, _croppedFile!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Adjust Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              _croppedFile,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cropImage,
              child: Text('Adjust and Crop'),
            ),
            ButtonWidget(
              text: 'Upload File',
              icon: Icons.cloud_upload_outlined,
              onClicked: uploadFile,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: ImageCropperScreen(
      imageFile: File('path_to_your_image'), // Provide the image file path
    ),
  ));
}
