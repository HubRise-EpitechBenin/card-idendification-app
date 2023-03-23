import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';

class User {
  String nom;
  String prenom;
  String numero;
  String profil;
  String heure;
  bool isOut;
  User(this.nom, this.prenom, this.numero, this.profil, this.heure, this.isOut);
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
      right = SizedBox(height: 60, width: 50, child: Text(tdata));
    } else {
      right = SizedBox(
          height: 60,
          width: 50,
          child: ElevatedButton(
              onPressed: () {
                setState(() => widget.user.isOut = true);
              },
              child: const Text('sortie')));
    }
    return right;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(height: 60, width: 65, child: Text(widget.user.nom)),
        SizedBox(height: 60, width: 65, child: Text(widget.user.prenom)),
        SizedBox(height: 60, width: 65, child: Text(widget.user.numero)),
        SizedBox(height: 60, width: 50, child: Text(widget.user.profil)),
        SizedBox(height: 60, width: 50, child: Text(widget.user.heure)),
        getWidget()
      ],
    );
  }
}
