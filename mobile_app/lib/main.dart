// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:card_app/takePicture.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';

import 'model/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(theme: ThemeData.dark(), home: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'card app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'home scan'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) async {
    var cam = await availableCameras();
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        // Navigator.pushNamed(
        //   context,
        //   '/services',
        // );
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
    final List<User> list = [
      User('Codo', 'Soraya', '548795', 'Etudiant', '09:22', false),
      User('Codo', 'Soraya', '548795', 'Etudiant', '09:22', true),
      User('Codo', 'Soraya', '548795', 'Etudiant', '09:22', false),
      User('Codo', 'Soraya', '548795', 'Etudiant', '09:22', true),
      User('Codo', 'Soraya', '548795', 'Etudiant', '09:22', false),
      User('Codo', 'Soraya', '548795', 'Etudiant', '09:22', true),
    ];
    return SafeArea(
        child: Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
          child: Column(children: <Widget>[
        //SizedBox(height: 200),
        Container(
            height: 200,
            child: Card(
              // margin: EdgeInsets.all(10),
              color: Colors.blue,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.calendar_month),
                    title: Text(getCurrentDate(),
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold)),
                    subtitle:
                        Text('Lorem ipsum', style: TextStyle(fontSize: 30)),
                  ),
                ],
              ),
            )),
        SizedBox(height: 30),
        Text('Tous les visiteurs',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            Text('Noms  '),
            Text('Prénoms'),
            Text('Numéro '),
            Text('Profil '),
            Text('HA     '),
            Text('HD     ')
          ],
        ),
        Container(
          height: 3,
          width: double.infinity,
          color: Colors.black,
        ),
        Flexible(
            child: ListView.builder(
                //scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return UserLine(user: list[index]);
                }))
      ])),
      bottomNavigationBar: Material(
          child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'all visitors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'add visitors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Active',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 119, 119, 119),
        onTap: _onItemTapped,
      )),
    ));
  }

  String getCurrentDate() {
    return DateFormat('d MMMM y').format(DateTime.now());
  }
}
