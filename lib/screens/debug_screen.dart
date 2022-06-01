import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/modals/notifications_consent_modal.dart';
import 'package:little_victories/widgets/modals/notifications_consent_modal.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  _DebugScreenState createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
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
          body: Column(
            children: <Widget>[
              // Little Victories Logo
              buildFlexibleImage(),
              const Spacer(),
              // Preferences Button

              buildNiceButton(
                'Notifications Consent',
                CustomColours.darkPurple,
                () => showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return const NotificationsConsentModal();
                  },
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
