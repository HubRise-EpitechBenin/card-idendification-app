// ignore_for_file: unused_element

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'form.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Widget _buildPictureArea(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 300,
      child: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //appBar: AppBar(title: const Text('Take a picture')),
      body: Column(children: <Widget>[
        SizedBox(
            height: 200,
            child: Card(
              // margin: EdgeInsets.all(10),
              color: Colors.blue,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: Text(getCurrentDate(),
                        style: const TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Lorem ipsum',
                        style: TextStyle(fontSize: 30)),
                  ),
                ],
              ),
            )),
        _buildPictureArea(context),
        const SizedBox(height: 15),
        const Text(
          "OR",
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(minimumSize: Size(100.0, 40.0)),
          onPressed: () {
            Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FormPage(),
            ),);
          },
          child: const Text("Add Manually"),
        )
      ]),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            if (!mounted) return;
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    ));
  }

  String getCurrentDate() {
    return DateFormat('d MMMM y').format(DateTime.now());
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
