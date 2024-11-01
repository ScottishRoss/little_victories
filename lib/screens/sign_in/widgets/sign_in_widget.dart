import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/lv_user_class.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/widgets/common/little_victories.dart';
import 'package:little_victories/widgets/common/loading.dart';
import 'package:little_victories/widgets/common/lv_logo.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Authentication.initializeFirebase(context: context),
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Loading();
          case ConnectionState.waiting:
            return const Loading();
          case ConnectionState.active:
            return _buildSignInPage;

          case ConnectionState.done:
            return _buildSignInPage;
        }
      },
    );
  }

  Widget get _buildSignInPage {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const LittleVictories(),
                const LVLogo(),
                _buildSocialLoginButtons,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _buildSocialLoginButtons {
    return Column(
      children: <Widget>[
        GoogleAuthButton(
          isLoading: _isLoading,
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            final LVUser? _user =
                await Authentication().signInWithGoogle(context: context);

            if (_user != null) {
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      ],
    );
  }
}
