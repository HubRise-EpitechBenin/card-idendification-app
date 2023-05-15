// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'form.dart';
import 'main.dart';
import 'network_handler.dart';

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
  final NetworkHandler _networkHandler = NetworkHandler();
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

  /*Widget _buildPictureArea(BuildContext context) {
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
  }*/

  Widget _buildPictureArea(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 300,
      child: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> sendImage(final imageFile) async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://osnel12-miniature-spork-j9v46xxgg562qwp6-8080.preview.app.github.dev/api/scan/'));
    request.files.add(await http.MultipartFile.fromPath(
        'card_image',
        imageFile
            .path)); // 'card_image' doit correspondre au nom de champ utilisé dans le serveur
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image envoyée avec succès');
    } else {
      print(
          'Échec de l\'envoi de l\'image. Code de statut ${response.statusCode}');
    }
  }

  Future<http.Response> uploadImage(final imageFile) async {
    final url = Uri.parse(
        'https://example.com/api/scan/'); // remplacez example.com par l'URL de votre serveur
    var request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath('card_image', imageFile.path));
    http.StreamedResponse response = await request.send();
    return await http.Response.fromStream(response);
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
                  SizedBox(height: 50.0, width: 80.0),
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
        //SizedBox(height: 50.0),
        SizedBox(height: 30),
        Text('Ajouter un visiteur',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        SizedBox(height: 30),
        _buildPictureArea(context),
        const SizedBox(height: 15),
        const Text(
          "OU",
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: Size(100.0, 40.0)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const FormPage(),
              ),
            );
          },
          child: const Text("Ajouter manuellement"),
        )
      ]),

      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            final bytes = await image.readAsBytes();
            if (!mounted) return;
            Map<String, String> data1 = {"card_image": base64Encode(bytes)};
            sendImage(image);
            // Map<String, String> data1 = {"card_image": image.path};
            // Map<String, String> data1 = {
            //   "card_image": base64Encode(bytes),
            //   "card_image_name": image.path.split('/').last
            // };
              var re = await _networkHandler.post('/scan/', data1);
            // //var re = await _networkHandler.get("/visitors/");
            if (re.statusCode == 200) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FormPage(),
                ),
              );
            } else {
              print("Error");
            }

            // await Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => DisplayPictureScreen(
            //       imagePath: image.path,
            //     ),
            //   ),
            // );
            // Fermer la caméra après la prise de vue
            _controller.dispose();
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),*/

      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            final bytes = await image.readAsBytes();
            print(bytes.length);
            if (!mounted || bytes.length == 0) return;
            Map<String, String> data1 = {"card_image": base64Encode(bytes)};
            // Envoi de l'image au serveur
            final response = await http.post(
                Uri.parse(
                    'https://osnel12-miniature-spork-j9v46xxgg562qwp6-8080.preview.app.github.dev/api/scan/'),
                body: data1);
            if (response.statusCode == 200) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FormPage(),
                ),
              );
            } else {
              print(
                  'Échec de l\'envoi de l\'image. Code de statut ${response.statusCode}');
            }

            // Fermer la caméra après la prise de vue
            _controller.dispose();
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            final bytes = await image.readAsBytes();
            final base64Image = base64Encode(bytes).toString();
            final fileName = path.basename(image.path);
            final fileExtension = path.extension(fileName);
            print(base64Image);
            final response = await http.post(
              Uri.parse(
                  'https://osnel12-bookish-space-cod-g6j59ggp5963ppg9-8080.preview.app.github.dev/api/scan/'),
              body: {'card_image': base64Image},
            );
            print(response.body);
            if (response.statusCode == 200) {
              print(response.body);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FormPage(),
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Erreur"),
                    content: Text(response.body),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                },
              );
              print(
                  'Échec de l\'envoi de l\'image. Code de statut ${response.statusCode}');
            }
            _controller.dispose();
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
