import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';

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
      insetPadding: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kModalPadding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(kModalPadding),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[
              CustomColours.lightPurple,
              CustomColours.teal,
            ],
          ),
          borderRadius: BorderRadius.circular(kModalPadding),
          boxShadow: const <BoxShadow>[
            BoxShadow(offset: Offset(0, 10), blurRadius: 10),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: kModalAvatarRadius,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(kModalAvatarRadius),
                ),
                child: Image.asset('assets/lv_logo_transparent.png'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Are you sure you want to sign out?',
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
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
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(CustomColours.darkPurple),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Authentication.signOutOfGoogle(context: context);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
