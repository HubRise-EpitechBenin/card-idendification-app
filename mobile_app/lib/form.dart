// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:card_app/takePicture.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

import 'main.dart';
import 'network_handler.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final NetworkHandler _networkHandler = NetworkHandler();
  String firstName = "";
  String lastName = "";
  String bodyTemp = "";
  var measure;
  int _selectedIndex = 1;
  void _onItemTapped(int index) async {
    var cam = await availableCameras();
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(title: 'homepage'),
            ));
      } else if (_selectedIndex == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => TakePictureScreen(camera: cam.first)));
      } else if (_selectedIndex == 2) {
        // Navigator.pushNamed(
        //   context,
        //   '/profile',
        // );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Nouveau Visiteur"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle, size: 32.0),
            tooltip: 'Profile',
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => MyProfilePage(),
              //     ));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 80),
        child: ListView(
          children: <Widget>[
            const Align(
              alignment: Alignment.topLeft,
              child: Text("Info du visiteur",
                  style: TextStyle(
                    fontSize: 24,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Nom',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    onFieldSubmitted: (value) {
                      setState(() {
                        firstName = value;
                        // firstNameList.add(firstName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        firstName = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return 'Le nom doit contenir au moins 3 caractères';
                      } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                        return 'Le nom ne peut pas contenir de caractères spéciaux';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Prénom',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return 'Le prénom doit contenir au moins 3 caractères';
                      } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                        return 'Le prénom ne peut pas contenir de caractères spéciaux';
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        lastName = value;
                        // lastNameList.add(lastName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        lastName = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Numéro de telephone',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                        return 'N\'utilisez que des chiffres !';
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        bodyTemp = value;
                        // bodyTempList.add(bodyTemp);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        bodyTemp = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      items: [
                        const DropdownMenuItem(
                          value: 1,
                          child: Text("Etudiant"),
                        ),
                        const DropdownMenuItem(
                          value: 2,
                          child: Text("Parent"),
                        ),
                        const DropdownMenuItem(
                          value: 3,
                          child: Text("Partenaire"),
                        ),
                        const DropdownMenuItem(
                          value: 4,
                          child: Text("Prestataire"),
                        ),
                        const DropdownMenuItem(
                          value: 5,
                          child: Text("Autre"),
                        )
                      ],
                      hint: const Text("Statut"),
                      onChanged: (value) {
                        setState(() {
                          measure = value;
                          // measureList.add(measure);
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          measure = value;
                        });
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60)),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // _submit();
                        // String firstName = "";
                        // String lastName = "";
                        // String bodyTemp = "";
                        // var measure;
                        final uuid = Uuid();
                        final uniqueId = uuid.v4();
                        Map<String, String> data1 = {
                          "last_name": lastName,
                          "first_names": firstName,
                          "phone_number": "+229" + bodyTemp,
                          "username": lastName,
                          "card_image": uniqueId.toString()
                        };
                        var re =
                            await _networkHandler.post("/visitors/", data1);
                        //var re = await _networkHandler.get("/visitors");
                        if (re.statusCode == 200 || re.statusCode == 201) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyHomePage(title: 'homepage'),
                              ));
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Erreur"),
                                content: Text(re.body),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              );
                            },
                          );
                          print('Échec. Code de statut ${re.statusCode}');
                        }
                      }
                    },
                    child: const Text("Ajouter"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
          child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Tous les visiteurs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Nouveaux visiteurs',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person_rounded),
          //   label: 'Actif',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 119, 119, 119),
        onTap: _onItemTapped,
      )),
    );
  }
}
