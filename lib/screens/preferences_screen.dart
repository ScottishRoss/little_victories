import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/delete_account_modal.dart';
import 'package:little_victories/widgets/sign_out_of_google_modal.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  late User _user;

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser!;

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
              buildNiceButton(
                'Delete Account',
                Colors.red.shade400,
                () {
                  showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteAccountBox(user: _user);
                    },
                  );
                },
                //textColor: CustomColours.darkPurple,
              ),

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
