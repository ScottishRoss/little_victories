import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
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
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Expanded(
            child: Column(
              children: <Widget>[
                // Little Victories Logo
                buildFlexibleImage(),
                const Spacer(),
                // Preferences Button
                buildNiceButton(
                  'Preferences',
                  CustomColours.darkPurple,
                  () => Navigator.pushNamed(context, '/preferences',
                      arguments: <User>[_user]),
                ),
                // View Victories
                buildNiceButton(
                  'View your Victories',
                  CustomColours.darkPurple,
                  () => Navigator.pushNamed(context, '/view_victories',
                      arguments: <User>[_user]),
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
      ),
    );
  }
}
