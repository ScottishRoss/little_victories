import 'package:flutter/material.dart';
import 'package:little_victories/screens/preferences/widgets/reminder_preferences.dart';

import '../../data/firestore_operations.dart';
import '../../util/custom_colours.dart';
import '../../util/utils.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/modals/account_modal.dart';
import '../../widgets/modals/sign_out_of_google_modal.dart';

class PreferencesWidget extends StatefulWidget {
  const PreferencesWidget({Key? key}) : super(key: key);

  @override
  _PreferencesWidgetState createState() => _PreferencesWidgetState();
}

class _PreferencesWidgetState extends State<PreferencesWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const ReminderPreferences(),
          CustomButton(
            'Delete Account',
            () {
              showDialog<Widget>(
                context: context,
                builder: (BuildContext context) {
                  return CustomModal(
                    title: 'Delete Victory',
                    desc: 'Are you sure you want to delete this Victory?',
                    button: _deleteAccountButton(),
                  );
                },
              );
            },
            marginBottom: 0,
            backgroundColor: Colors.red.shade400,
            borderColor: Colors.red.shade400,
          ),
          CustomButton(
            'Sign Out',
            () => showDialog<Widget>(
              context: context,
              builder: (BuildContext context) {
                return const SignOutOfGoogleBox();
              },
            ),
          ),
          CustomButton(
            'Back',
            () => Navigator.pushNamed(
              context,
              '/home',
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _deleteAccountButton() {
    return buildOutlinedButton(
        textType: 'Delete Account',
        iconData: Icons.delete_forever,
        textSize: 15,
        backgroundColor: CustomColours.darkPurple,
        onPressed: () async {
          await deleteUser();

          Navigator.pushNamedAndRemoveUntil(
              context, '/sign_in', (Route<dynamic> route) => false);
        });
  }
}
