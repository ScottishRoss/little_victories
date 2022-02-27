import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/utils.dart';

class PushNotificationsScreen extends StatefulWidget {
  const PushNotificationsScreen({Key? key}) : super(key: key);

  @override
  _PushNotificationsScreenState createState() =>
      _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  late User _user;
  late Stream<QuerySnapshot<Object?>> _pushNotificationSettingsStream;

  @override
  void initState() {
    super.initState();
    _user = _user = FirebaseAuth.instance.currentUser!;

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
          colors: <Color>[CustomColours.darkPurple, CustomColours.teal],
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
              buildFlexibleImage(),
              const Spacer(),
              SizedBox(
                height: 200,
                child: StreamBuilder<QuerySnapshot<Object?>>(
                  stream: _pushNotificationSettingsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
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
                          final dynamic result =
                              snapshot.data!.docs.first.data();

                          return ListView.builder(
                            itemCount: result.length as int?,
                            itemBuilder: (BuildContext context, int index) {
                              final String key =
                                  result.keys.elementAt(index) as String;
                              final dynamic value =
                                  result.values.elementAt(index);
                              return Column(
                                children: <Widget>[
                                  SwitchListTile(
                                    title: Text(key),
                                    value: value as bool,
                                    onChanged: (bool value) {},
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
