import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:little_victories/screens/sign_in/widgets/sign_in_background.dart';
import 'package:little_victories/screens/sign_in/widgets/sign_in_widget.dart';
import 'package:little_victories/widgets/common/no_internet_connection.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  InternetStatus? _connectionStatus;
  late StreamSubscription<InternetStatus> _subscription;

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
    _subscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      setState(() {
        _connectionStatus = status;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isUserSignedIn();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_connectionStatus) {
      case InternetStatus.connected:
        return const SignInBackground(child: SignInWidget());
      case InternetStatus.disconnected:
        return const SignInBackground(child: NoInternetConnection());

      case null:
        return const SignInBackground(child: NoInternetConnection());
    }
  }
}
