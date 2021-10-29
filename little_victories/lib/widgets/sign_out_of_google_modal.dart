import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class SignOutOfGoogleBox extends StatefulWidget {
  const SignOutOfGoogleBox({Key? key}) : super(key: key);

  @override
  _SignOutOfGoogleBoxState createState() => _SignOutOfGoogleBoxState();
}

class _SignOutOfGoogleBoxState extends State<SignOutOfGoogleBox> {
  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/sign_in', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  // ignore: type_annotate_public_apis
  Stack contentBox(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        padding: const EdgeInsets.only(
          left: Constants.padding,
          top: 10,
          right: Constants.padding,
          bottom: Constants.padding,
        ),
        margin: const EdgeInsets.only(top: Constants.avatarRadius),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[
                CustomColours.lightPurple,
                CustomColours.teal,
              ],
            ),
            borderRadius: BorderRadius.circular(Constants.padding),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: <BoxShadow>[
              const BoxShadow(offset: Offset(0, 10), blurRadius: 10),
            ]),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const SizedBox(height: 20),
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Constants.avatarRadius)),
                child: Image.asset('assets/lv_logo_transparent.png')),
          ),
          Container(
            margin: const EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[
                  CustomColours.lightPurple,
                  CustomColours.teal,
                ],
              ),
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: const <BoxShadow>[
                BoxShadow(offset: Offset(0, 10), blurRadius: 10),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: Constants.avatarRadius,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Constants.avatarRadius)),
                      child: Image.asset('assets/lv_logo_transparent.png')),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                      'Are you sure you want to sign out of Little Victories?',
                      textScaleFactor: 1.2,
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(this.context).pop();
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.redAccent),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Authentication.signOutOfGoogle(context: context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: <Widget>[
                          const Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Icon(Icons.close, size: 20, color: Colors.white)
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]),
      )
    ]);
  }
}
