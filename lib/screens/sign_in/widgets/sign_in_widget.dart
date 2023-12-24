import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/screens/sign_in/widgets/tag_line.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/common/buttons.dart';
import 'package:little_victories/widgets/common/lv_logo.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Authentication.initializeFirebase(context: context),
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.hasError) {
          return const Text(
            'Error signing in, please try again later.',
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: const Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Little Victories Logo
                      LVLogo(),
                      TagLine(),
                      GoogleSignInButton(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return buildCircleProgressIndicator(
          color: CustomColours.teal,
        );
      },
    );
  }
}
