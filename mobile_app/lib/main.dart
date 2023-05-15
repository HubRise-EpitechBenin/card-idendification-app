// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:card_app/takePicture.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';

import 'model/user.dart';
import 'network_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final NetworkHandler _networkHandler = NetworkHandler();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'card app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'home scan'),
      debugShowCheckedModeBanner: false,
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
  List<User> _users = [];
  final NetworkHandler _networkHandler = NetworkHandler();
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
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    final response = await _networkHandler.get("/visitors/");
    DateTime now = DateTime.now();
    String currentTime = '${now.hour}:${now.minute}';
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<User> users = jsonData
          .map((data) => User(
                data['first_names'],
                data['last_name'],
                data['phone_number'].substring(4),
                currentTime,
                false,
              ))
          .toList();
      final newUsers = users.toSet().difference(_users.toSet());
      _users.addAll(newUsers);
      setState(() {
        //_users = users;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Widget build(BuildContext context) {
    // var re = _networkHandler.get("/visitors/");
    // //final List<dynamic> jsonData = json.decode(re.body);
    // final List<User> list = [
    //   User('Codo', 'Soraya', '61665803', '09:22', false),
    //   User('Codo', 'Soraya', '61665803', '09:22', true),
    //   User('Codo', 'Soraya', '61665803', '09:22', false),
    //   User('Codo', 'Soraya', '61665803', '09:22', true),
    //   User('Codo', 'Soraya', '61665803', '09:22', false),
    //   User('Codo', 'Soraya', '61665803', '09:22', true),
    // ];
    //_fetchUsers();

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
                //mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(height: 50.0, width: 80.0),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SizedBox(width: 5.0),
            SizedBox(width: 61, child: Text('Noms')),
            SizedBox(width: 70, child: Text('Prénoms')),
            SizedBox(width: 75, child: Text('Numéro')),
            SizedBox(width: 65, child: Text('Arrivé(e)')),
            SizedBox(width: 65, child: Text('Départ')),
            //SizedBox(height: 15),
            //   Text('Noms  '),
            //   Text('Prénoms'),
            //   Text('Numéro '),
            //  // Text('Profil '),
            //   Text('HA     '),
            //   Text('HD     ')
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Container(
            height: 3,
            width: double.infinity,
            color: Colors.black,
          ),
        ),
        Flexible(
            child: ListView.builder(
                //scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 8.0, right: 18.0),
                    child: UserLine(user: _users[index]),
                  );
                }))
      ])),
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
    ));
  }

  String getCurrentDate() {
    return DateFormat('d MMMM y').format(DateTime.now());
  }
}
