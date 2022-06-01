import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/preferences_model.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/res/secure_storage.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/modals/delete_account_modal.dart';
import 'package:little_victories/widgets/modals/sign_out_of_google_modal.dart';
import 'package:little_victories/widgets/preferences/reminders_switch_widget.dart';
import 'package:little_victories/widgets/preferences/set_reminder_time.dart';

import '../res/constants.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final SecureStorage _secureStorage = SecureStorage();

  late User _user;

  Future<Preferences> getPreferences() async {
    final String? _notificationsValue =
        await _secureStorage.getFromSecureStorage(kIsNotificationsEnabled);
    final bool _notificationsValueBool =
        // ignore: avoid_bool_literals_in_conditional_expressions
        _notificationsValue == 'true' ? true : false;

    return Preferences(isNotificationsEnabled: _notificationsValueBool);
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    getPreferences();
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
                                    isPreferencesEnabled:
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
                  '/home',
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
