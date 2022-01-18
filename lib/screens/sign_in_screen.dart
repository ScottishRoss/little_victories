import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/buttons.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      // Little Victories Logo
                      buildFlexibleImage(),
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
                        'Error signing in, please try again later.',
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return const GoogleSignInButton();
                    }
                    return buildCircleProgressIndicator(
                      color: CustomColours.teal,
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
