import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/res/notifications_service.dart';
import 'package:little_victories/res/secure_storage.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/delete_account_modal.dart';
import 'package:little_victories/widgets/preferences/reminders_widget.dart';
import 'package:little_victories/widgets/sign_out_of_google_modal.dart';

import '../res/constants.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final SecureStorage _secureStorage = SecureStorage();

  late User _user;

  Future<bool> getNotificationValues() async {
    final String? _notificationsValue =
        await _secureStorage.getFromSecureStorage(kIsNotificationsEnabled);
    final bool _notificationsValueBool =
        // ignore: avoid_bool_literals_in_conditional_expressions
        _notificationsValue == 'true' ? true : false;
    print(_notificationsValue);
    return _notificationsValueBool;
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    getNotificationValues();
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
                      children: <Widget>[
                        FutureBuilder<bool>(
                          future: getNotificationValues(),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              case ConnectionState.done:
                                if (snapshot.hasError)
                                  return Text(snapshot.error.toString());
                                else
                                  return RemindersWidget(
                                    isPreferencesEnabled: snapshot.data!,
                                  );
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
