import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/common/buttons.dart';
import 'package:little_victories/widgets/common/lv_logo.dart';
import 'package:little_victories/widgets/common/page_body.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  void isUserSignedIn() {
    final User? _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isUserSignedIn();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child:

          /// Sign in with Google
          FutureBuilder<FirebaseApp>(
        future: Authentication.initializeFirebase(context: context),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            return const Text(
              'Error signing in, please try again later.',
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: const <Widget>[
                      // Little Victories Logo
                      LVLogo(),
                      Text(
                        'Celebrate your Little Victories',
                        style: TextStyle(
                          color: CustomColours.teal,
                          fontSize: 20,
                        ),
                      ),
                      Spacer(),
                      GoogleSignInButton(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          }

          return buildCircleProgressIndicator(
            color: CustomColours.teal,
          );
        },
      ),
    );
  }
}
