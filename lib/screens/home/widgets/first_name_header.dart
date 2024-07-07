import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirstNameHeader extends StatefulWidget {
  const FirstNameHeader({Key? key}) : super(key: key);

  @override
  State<FirstNameHeader> createState() => _FirstNameHeaderState();
}

class _FirstNameHeaderState extends State<FirstNameHeader> {
  String _getFirstName() {
    String? firstName = FirebaseAuth.instance.currentUser?.displayName;
    if (firstName != null) {
      // split name to get the first name
      firstName = firstName.split(' ')[0];
    } else {
      firstName = 'Friend';
    }
    log('Getting firstName... $firstName');
    return firstName;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        'Hi ${_getFirstName()}',
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          fontSize: 60,
        ),
      ),
    );
  }
}
