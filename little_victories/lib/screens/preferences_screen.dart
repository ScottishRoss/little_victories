import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/widgets/nice_buttons.dart';
import 'package:little_victories/widgets/sign_out_of_google_modal.dart';

// TODO: Add delete account function.

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  late User _user;
  // ignore: unused_field
  final bool _isSigningOut = false;

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CustomColours.darkPurple, CustomColours.teal],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Little Victories Logo
              Flexible(
                flex: 4,
                child: Image.asset(
                  'assets/lv_main.png',
                ),
              ),
              const Spacer(),
              NiceButton(
                  width: double.infinity,
                  fontSize: 18.0,
                  elevation: 10.0,
                  radius: 52.0,
                  text: "Push Notifications",
                  background: CustomColours.darkPurple,
                  onPressed: () {
                    Navigator.pushNamed(context, '/push_notifications',
                        arguments: _user);
                  }),
              NiceButton(
                width: double.infinity,
                fontSize: 18.0,
                elevation: 10.0,
                radius: 52.0,
                text: "Sign out of Google",
                background: CustomColours.darkPurple,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const SignOutOfGoogleBox();
                      });
                },
              ),
              const Spacer(),
              NiceButton(
                  width: double.infinity,
                  fontSize: 18.0,
                  elevation: 10.0,
                  radius: 52.0,
                  text: "Back",
                  background: CustomColours.darkPurple,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home', arguments: _user);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
