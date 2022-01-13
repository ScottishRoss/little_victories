import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/utils.dart';
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

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // Little Victories Logo
              buildFlexibleImage(),
              const Spacer(),
              // buildNiceButton(
              //   'Push Notifications',
              //   CustomColours.darkPurple,
              //   () => Navigator.pushNamed(context, '/push_notifications',
              //       arguments: <User>[_user]),
              // ),
              buildNiceButton(
                'Sign Out',
                CustomColours.darkPurple,
                () => showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return const SignOutOfGoogleBox();
                  },
                ),
              ),
              const Spacer(),
              buildNiceButton(
                'Back',
                CustomColours.darkPurple,
                () => Navigator.pushNamed(
                  context,
                  '/homeFromPreferences',
                  arguments: <User>[_user],
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
