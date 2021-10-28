import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/message.dart';
import 'package:little_victories/util/navigation_helper.dart';
import 'package:little_victories/widgets/add_victory_modal.dart';
import 'package:little_victories/widgets/nice_buttons.dart';

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
        Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true));
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
      Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [CustomColours.darkPurple, CustomColours.teal])),
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
              // Preferences Button
              Container(
                margin: const EdgeInsets.all(15.0),
                child: NiceButton(
                    width: double.infinity,
                    fontSize: 18.0,
                    elevation: 10.0,
                    radius: 52.0,
                    text: "Preferences",
                    background: CustomColours.darkPurple,
                    onPressed: () {
                      NavigationHelper()
                          .navigateToPreferencesScreen(context, _user);
                    }),
              ),
              // View Victories
              Container(
                margin: const EdgeInsets.all(15.0),
                child: NiceButton(
                  width: double.infinity,
                  fontSize: 18.0,
                  elevation: 10.0,
                  radius: 52.0,
                  text: "View your Victories",
                  background: CustomColours.darkPurple,
                  onPressed: () => {
                    NavigationHelper.navigateToViewVictoriesScreen(
                        context, _user)
                  },
                ),
              ),
              const Spacer(),
              // Celebrate a Victory
              Container(
                margin: const EdgeInsets.all(15.0),
                child: NiceButton(
                  width: double.infinity,
                  fontSize: 20.0,
                  elevation: 10.0,
                  radius: 40.0,
                  background: CustomColours.lightPurple,
                  text: "Celebrate a Victory",
                  // ignore: prefer_const_literals_to_create_immutables
                  gradientColors: [
                    CustomColours.darkPurple,
                    CustomColours.teal
                  ],
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddVictoryBox(user: _user);
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
