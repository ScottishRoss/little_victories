import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:little_victories/screens/preferences_screen.dart';
import 'package:little_victories/screens/push_notifications_screen.dart';
import 'package:little_victories/screens/view_victories_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Little Victories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          brightness: Brightness.dark,
          fontFamily: 'Montserrat'),
      home: _user != null ? HomeScreen(user: _user!) : SignInScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageTransition(
                child: HomeScreen(user: _user!), type: PageTransitionType.fade);
          case '/preferences':
            return PageTransition(
                child: PreferencesScreen(user: _user!),
                type: PageTransitionType.fade);
          case '/push_notifications':
            return PageTransition(
                child: PushNotificationsScreen(user: _user!),
                type: PageTransitionType.fade);
          case '/sign_in':
            return PageTransition(
                child: SignInScreen(), type: PageTransitionType.fade);
          case '/view_victories':
            return PageTransition(
                child: ViewVictoriesScreen(user: _user!),
                type: PageTransitionType.fade);
          default:
            return null;
        }
      },
    );
  }
}