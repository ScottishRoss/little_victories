import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/data/preferences_model.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/secure_storage.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/common/custom_button.dart';
import 'package:little_victories/widgets/common/lv_logo.dart';
import 'package:little_victories/widgets/common/page_body.dart';
import 'package:little_victories/widgets/modals/account_modal.dart';
import 'package:little_victories/widgets/modals/sign_out_of_google_modal.dart';
import 'package:little_victories/widgets/preferences/reminders_switch_widget.dart';
import 'package:little_victories/widgets/preferences/reminders_timepicker_widget.dart';

import '../../res/constants.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final SecureStorage _secureStorage = SecureStorage();

  late User user;

  Future<Preferences> getPreferences() async {
    final String? _notificationsSwitchValue =
        await _secureStorage.getFromKey(kIsNotificationsEnabled);
    final String? _notificationTime =
        await _secureStorage.getFromKey(kNotificationTime);
    final bool _notificationsValueBool =
        // ignore: avoid_bool_literals_in_conditional_expressions
        _notificationsSwitchValue == 'true' ? true : false;

    return Preferences(
      isNotificationsEnabled: _notificationsValueBool,
      notificationTime: _notificationTime,
    );
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const LVLogo(),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FutureBuilder<Preferences>(
                      future: getPreferences(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Preferences> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.done:
                            if (snapshot.hasError)
                              return Text(snapshot.error.toString());
                            else
                              return RemindersSwitchWidget(
                                isNotificationsEnabled:
                                    snapshot.data!.isNotificationsEnabled,
                              );
                          default:
                            return Container();
                        }
                      },
                    ),
                    FutureBuilder<Preferences>(
                      future: getPreferences(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Preferences> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.done:
                            if (snapshot.hasError)
                              return Text(snapshot.error.toString());
                            else
                              return const ReminderTimepickerWidget();
                          default:
                            return Container();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          CustomButton(
            'Delete Account',
            () {
              showDialog<Widget>(
                context: context,
                builder: (BuildContext context) {
                  return CustomModal(
                    user: user,
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
          const Spacer(),
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
          await deleteUser(
            user,
          );

          Navigator.pushNamedAndRemoveUntil(
              context, '/sign_in', (Route<dynamic> route) => false);
        });
  }
}
