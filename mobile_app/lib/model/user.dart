import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';

class User {
  String nom;
  String prenom;
  String numero;
  //String profil;
  String heure;
  bool isOut;
  User(this.nom, this.prenom, this.numero /*, this.profil*/, this.heure,
      this.isOut);
}

class UserLine extends StatefulWidget {
  const UserLine({super.key, required this.user});
  final User user;
  @override
  State<UserLine> createState() => _UserLineState();
}

class _UserLineState extends State<UserLine> {
  Widget getWidget() {
    Widget right;
    String tdata = DateFormat("HH:mm").format(DateTime.now());
    if (widget.user.isOut) {
      //right = Text(tdata);
      right = ElevatedButton(
        onPressed: () {
          setState(() => widget.user.isOut = true);
        },
        child: Text(tdata),
        style: ElevatedButton.styleFrom(
          fixedSize: Size(69, 50),
          backgroundColor: Colors.red
        ),
      );
    } else {
      // right = TextButton(
      //   style: TextButton.styleFrom(
      //     foregroundColor: Colors.black,
      //     //padding: const EdgeInsets.all(16.0),
      //     textStyle: const TextStyle(fontSize: 12),
      //   ),
      //   onPressed: () {},
      //   child: const Text('Gradient'),
      // );
      right = ElevatedButton(
        onPressed: () {
          setState(() => widget.user.isOut = true);
        },
        child: const Text('sortie'),
        style: ElevatedButton.styleFrom(
          fixedSize: Size(69, 50),
        ),
      );
    }
    return right;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /*Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 60, width: 65, child: Text(widget.user.nom)),
            ],
          ),*/
          
          Text(widget.user.nom),
          Text(widget.user.prenom),
          Text(widget.user.numero),
          Text(widget.user.heure),
          // SizedBox(height: 60, width: 65, child: Text(widget.user.nom)),
          // SizedBox(height: 60, width: 65, child: Text(widget.user.prenom)),
          // SizedBox(height: 60, width: 65 + 30, child: Text(widget.user.numero)),
          // //SizedBox(height: 60, width: 50, child: Text(widget.user.profil)),
          // SizedBox(height: 60, width: 40, child: Text(widget.user.heure)),
          //SizedBox(height: 60, width: 60, child: getWidget())
          getWidget(),
        ],
      ),
    );
  }
}
