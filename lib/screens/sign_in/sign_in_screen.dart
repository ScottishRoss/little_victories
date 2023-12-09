import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/constants.dart';
import '../../util/authentication.dart';
import '../../util/custom_colours.dart';
import '../../util/utils.dart';
import '../../widgets/common/buttons.dart';
import '../../widgets/common/lv_logo.dart';

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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isUserSignedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  CustomColours.darkBlue,
                  CustomColours.darkBlue,
                  CustomColours.teal,
                ],
              ),
            ),
          ),

          /// Sign in with Google
          FutureBuilder<FirebaseApp>(
            future: Authentication.initializeFirebase(context: context),
            builder:
                (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  'Error signing in, please try again later.',
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Little Victories Logo
                            const LVLogo(),
                            _tagline,
                            const GoogleSignInButton(),
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
          ),
        ],
      ),
    );
  }

  Widget get _tagline {
    return Column(
      children: <Widget>[
        AutoSizeText(
          'Celebrate your',
          style: kTitleText.copyWith(
            fontSize: 22,
          ),
        ),
        AutoSizeText(
          'Little Victories',
          style: kTitleText.copyWith(
            fontSize: 46,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}
