import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/screens/sign_in/widgets/sign_in_widget.dart';
import 'package:little_victories/util/custom_colours.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  void isUserSignedIn() {
    final User? _user = FirebaseAuth.instance.currentUser;
    log('isUserSignedIn: $_user');
    if (_user != null) {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isUserSignedIn();
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: CustomColours.darkBlue,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SignInWidget(),
      );
}
