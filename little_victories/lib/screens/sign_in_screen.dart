import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/widgets/buttons.dart';
import '../util/utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[CustomColours.darkPurple, CustomColours.teal])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Column(
              children: <Widget>[
                Row(),

                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Little Victories Logo
                      buildFlexibleImage(),
                      //SizedBox(height: 10),
                      const Text(
                        'Celebrate your Little Victories',
                        style: TextStyle(
                          color: CustomColours.teal,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Sign in with Google
                FutureBuilder<FirebaseApp>(
                  future: Authentication.initializeFirebase(context: context),
                  builder: (BuildContext context,
                      AsyncSnapshot<FirebaseApp> snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                          'Error initializing connection, please try again later.');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return const GoogleSignInButton();
                    }
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColours.lightPurple,
                      ),
                    );
                  },
                ),
                FutureBuilder<FirebaseApp>(
                  future: Authentication.initializeFirebase(context: context),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                          'Error initializing connection, please try again later.');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return const TwitterSignInButton();
                    }
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColours.lightPurple,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
