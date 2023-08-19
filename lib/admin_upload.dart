import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:library_assignment/api/firebase_api.dart';
import 'package:library_assignment/crop_image.dart';
import 'package:library_assignment/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();

  runApp(admin_upload());
}

class admin_upload extends StatelessWidget {
  static final String title = 'Firebase Upload';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.green),
    home: MainPage(),
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  UploadTask? task;
  File? file;

  File? selectedImage;

  void showSelectedImage() {
    if (file != null) {
      setState(() {
        selectedImage = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        title: Text(admin_upload.title),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                height: 200,
                width: 200,
                color: Colors.grey.shade300,
                child: ButtonWidget(
                  text: '',
                  icon: Icons.add,
                  onClicked: selectFile,
                )
              ),

              /*ButtonWidget(
                text: 'Select File',
                icon: Icons.attach_file,
                onClicked: selectFile,
              ),
              SizedBox(height: 8),
              Text(
                fileName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),*/

              SizedBox(height: 20),
              task != null ? buildUploadStatus(task!) : Container(),

              // Display selected image if available
              file != null
                  ? Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Image.file(
                  file!,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(),
              SizedBox(height: 48),

              /*ButtonWidget(
                text: 'Upload File',
                icon: Icons.cloud_upload_outlined,
                onClicked: uploadFile,
              ),*/
              // Add a button to navigate to the preview screen
              SizedBox(height: 20),
            // Add a button to navigate to the preview screen
            SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                    print('Navigating to preview screen');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            //ImagePreviewScreen(image: file!),
                        ImageCropperScreen(imageFile: file!)
                      ),
                    );
                },
                child: Text('Preview Image'),
              ),




            ],
          ),
        ),
      ),
    );
  }



  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );
}

class ImagePreviewScreen extends StatelessWidget {
  final File image;

  const ImagePreviewScreen({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Preview'),
      ),
      body: Center(
        child: Image.file(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

Future<File?> _cropImage({required File imageFile}) async {
  CroppedFile? croppedImage =
  await ImageCropper().cropImage(sourcePath: imageFile.path);
  if (croppedImage == null) return null;
  return File(croppedImage.path);
}


/*class ImagePreviewScreen extends StatefulWidget {
  final File image;

  const ImagePreviewScreen({required this.image});

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  File? croppedImage;

  Future<void> _cropImage() async {
    File? cropped = await ImageCropper.cropImage(
      sourcePath: widget.image.path,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.deepOrange,
        statusBarColor: Colors.deepOrange.shade900,
        backgroundColor: Colors.white,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );



    if (cropped != null) {
      setState(() {
        croppedImage = cropped;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Preview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (croppedImage == null)
              Image.file(
                widget.image,
                fit: BoxFit.cover,
              )
            else
              Image.file(
                croppedImage!,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cropImage,
              child: Text('Crop Image'),
            ),
          ],
        ),
      ),
    );
  }
}*/
