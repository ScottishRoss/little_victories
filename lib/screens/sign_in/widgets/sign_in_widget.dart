import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/screens/sign_in/widgets/tag_line.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/widgets/common/google_sign_in_button.dart';
import 'package:little_victories/widgets/common/lv_logo.dart';
import 'package:little_victories/widgets/common/no_internet_connection.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: Authentication.initializeFirebase(context: context),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const NoInternetConnection();
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              return _buildSignInPage;

            case ConnectionState.done:
              return _buildSignInPage;
          }
        });
  }

  Widget get _buildSignInPage {
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
}
