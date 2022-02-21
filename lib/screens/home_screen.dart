import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/add_victory_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  // ignore: unused_field
  final User _user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;

  @override
  void initState() {
    _user = widget._user;
    Authentication().authCheck(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              // Little Victories Logo
              buildFlexibleImage(),
              const Spacer(),
              // Preferences Button
              buildNiceButton(
                'Preferences',
                CustomColours.darkPurple,
                () => Navigator.pushNamed(
                  context,
                  '/preferences',
                  arguments: <User>[_user],
                ),
              ),
              // View Victories
              buildNiceButton(
                'View your Victories',
                CustomColours.darkPurple,
                () => Navigator.pushNamed(
                  context,
                  '/view_victories',
                  arguments: <User>[_user],
                ),
              ),
              const Spacer(),
              // Celebrate a Victory
              buildNiceButton(
                'Celebrate a Victory',
                CustomColours.darkPurple,
                () => showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return AddVictoryBox(user: _user);
                    }),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
