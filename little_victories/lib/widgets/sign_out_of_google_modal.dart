import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/navigation_helper.dart';
import 'package:little_victories/util/utils.dart';

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
  // ignore: prefer_typing_uninitialized_variables
  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser == null) {
      // ignore: unnecessary_statements
      Navigator.pushNamed(context, '/sign_in');
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
    return Stack(
      children: <Widget>[
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
                colors: [
                  CustomColours.lightPurple,
                  CustomColours.teal,
                ],
              ),
              const Spacer(),
              buildOutlinedButton(
                textType: 'Sign Out',
                iconData: Icons.close,
                textColor: Colors.white,
                textSize: 15,
                onPressed: () async {
                  Authentication.signOutOfGoogle(context: context);
                },

              ),
            ],
          ),
        )
      ],
    );
  }
}
