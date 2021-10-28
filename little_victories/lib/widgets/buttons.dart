import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/screens/home_screen.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/navigation_helper.dart';

/// Google

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  // bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return const SignInButtonLogic(
      platform: 'Google',
      imageLogo: 'assets/google_logo.png',
    );

    // Padding(
    //   padding: const EdgeInsets.only(bottom: 16.0),
    //   child: _isSigningIn
    //       ? const CircularProgressIndicator(
    //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    //         )
    //       : OutlinedButton(
    //           style: ButtonStyle(
    //             backgroundColor: MaterialStateProperty.all(Colors.white),
    //             shape: MaterialStateProperty.all(
    //               RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(40),
    //               ),
    //             ),
    //           ),
    //           onPressed: () async {
    //             setState(() {
    //               _isSigningIn = true;
    //             });

    //             final User? user =
    //                 await Authentication().signInWithGoogle(context: context);

    //             setState(() {
    //               _isSigningIn = false;
    //             });

    //             if (user != null) {
    //               NavigationHelper().navigateToHomePageScreen(context, user);
    //             }
    //           },
    //           child: Padding(
    //             padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
    //             child: Row(
    //               mainAxisSize: MainAxisSize.min,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: const <Widget>[
    //                 // ignore: prefer_const_literals_to_create_immutables
    //                 Image(
    //                   image: AssetImage("assets/google_logo.png"),
    //                   height: 35.0,
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.only(left: 10),
    //                   child: Text(
    //                     'Continue with Google',
    //                     style: TextStyle(
    //                       fontSize: 20,
    //                       color: Colors.black54,
    //                       fontWeight: FontWeight.w600,
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    // );
  }
}

/// Twitter Sign In

class TwitterSignInButton extends StatefulWidget {
  const TwitterSignInButton({Key? key}) : super(key: key);

  @override
  _TwitterSignInButtonState createState() => _TwitterSignInButtonState();
}

class _TwitterSignInButtonState extends State<TwitterSignInButton> {
  @override
  Widget build(BuildContext context) {
    return const SignInButtonLogic(
      platform: 'Twitter',
      imageLogo: 'assets/twitter_logo.png',
    );
  }
}

/// signIn button

class SignInButtonLogic extends StatefulWidget {
  final String platform;
  final String imageLogo;
  const SignInButtonLogic({
    required this.platform,
    required this.imageLogo,
    Key? key,
  }) : super(key: key);

  @override
  _SignInButtonLogicState createState() => _SignInButtonLogicState();
}

class _SignInButtonLogicState extends State<SignInButtonLogic> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    final String platform = widget.platform;
    final String logo = widget.imageLogo;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                final User? user = platform == 'Google'
                    ? await Authentication().signInWithGoogle(context: context)
                    : await Authentication()
                        .signInWithTwitter(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  NavigationHelper().navigateToHomePageScreen(context, user);
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // ignore: prefer_const_literals_to_create_immutables
                    Image(
                      image: AssetImage(logo),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Continue with $platform',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class SaveVictoryButton extends StatefulWidget {
  const SaveVictoryButton(
      {Key? key, required User user, required String victory})
      : _user = user,
        _victory = victory,
        super(key: key);

  final User _user;
  final String _victory;

  @override
  _SaveVictoryButtonState createState() => _SaveVictoryButtonState();
}

class _SaveVictoryButtonState extends State<SaveVictoryButton> {
  bool _isSuccess = false;
  late User _user;
  late String _victory;

  @override
  void initState() {
    _user = widget._user;
    _victory = widget._victory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isSuccess
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                _isSuccess = await saveLittleVictory(_user, _victory);

                if (_isSuccess) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        user: _user,
                      ),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'Celebrate a Victory',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.celebration, size: 10)
                ],
              ),
            ),
    );
  }
}
