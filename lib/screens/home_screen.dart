import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/add_victory_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
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
          body: DoubleBackToCloseApp(
            child: Column(
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
                  ),
                ),
                // View Victories
                buildNiceButton(
                  'View your Victories',
                  CustomColours.darkPurple,
                  () => Navigator.pushNamed(
                    context,
                    '/view_victories',
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
                        return const AddVictoryBox();
                      }),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
            snackBar: const SnackBar(
              backgroundColor: CustomColours.lightPurple,
              content: Text(
                'Tap back again to leave',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
