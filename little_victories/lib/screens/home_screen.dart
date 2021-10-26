import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/message.dart';
import 'package:little_victories/util/navigation_helper.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/add_victory_modal.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;

  @override
  void initState() {
    _user = widget._user;

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Navigator.pushNamed(
          context,
          '/message',
          arguments: MessageArguments(message, true),
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final RemoteNotification notification = message.notification!;
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.pushNamed(
        context,
        '/message',
        arguments: MessageArguments(message, true),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(),
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
              // Preferences Button
              Container(
                margin: const EdgeInsets.all(15.0),
                child: buildNiceButton(
                    "Preferences",
                    CustomColours.darkPurple,
                    () => NavigationHelper()
                        .navigateToPreferencesScreen(context, _user)),
              ),
              // View Victories
              Container(
                margin: const EdgeInsets.all(15.0),
                child: buildNiceButton(
                    "View your Victories",
                    CustomColours.darkPurple,
                    () => NavigationHelper.navigateToViewVictoriesScreen(
                        context, _user)),
              ),
              const Spacer(),
              // Celebrate a Victory
              Container(
                margin: const EdgeInsets.all(15.0),
                child: buildNiceButton(
                  "Celebrate a Victory",
                  CustomColours.lightPurple,
                  () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddVictoryBox(user: _user);
                      }),
                  radius: 40.0,
                  fontSize: 20.0,
                  gradientColors: [
                    CustomColours.darkPurple,
                    CustomColours.teal
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
