import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/navigation_helper.dart';
import 'package:little_victories/widgets/nice_buttons.dart';

class PushNotificationsScreen extends StatefulWidget {
  const PushNotificationsScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _PushNotificationsScreenState createState() =>
      _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  late User _user;
  late Stream<QuerySnapshot> _pushNotificationSettingsStream;

  @override
  void initState() {
    super.initState();
    _user = widget._user;

    _pushNotificationSettingsStream = firestore
        .collection('users')
        .doc(_user.uid)
        .collection('topics')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CustomColours.darkPurple, CustomColours.teal],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Little Victories Logo
              Flexible(
                flex: 4,
                child: Image.asset(
                  'assets/lv_main.png',
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 200,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _pushNotificationSettingsStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data?.docs == null) {
                          return const Center(
                              child: Text('No Victories to show'));
                        } else {
                          final Map<String, dynamic> result =
                              snapshot.data!.docs.first.data();

                          return ListView.builder(
                            itemCount: result.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String key = result.keys.elementAt(index);
                              final dynamic value =
                                  result.values.elementAt(index);
                              return Column(
                                children: <Widget>[
                                  SwitchListTile(
                                    title: Text(key),
                                    value: value as bool,
                                    onChanged: (bool value) {
                                      // TODO: Update document on switch change.
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                    }
                  },
                ),
              ),

              const Spacer(),
              Container(
                margin: const EdgeInsets.all(15.0),
                child: NiceButton(
                    width: double.infinity,
                    fontSize: 18.0,
                    elevation: 10.0,
                    radius: 52.0,
                    text: "Back",
                    background: CustomColours.darkPurple,
                    onPressed: () {
                      NavigationHelper()
                          .navigateToHomePageScreen(context, _user);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
