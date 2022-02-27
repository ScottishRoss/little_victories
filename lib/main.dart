import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/screens/preferences_screen.dart';
import 'package:little_victories/screens/push_notifications_screen.dart';
import 'package:little_victories/screens/view_victories_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Little Victories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        highlightColor: CustomColours.teal,
      ),
      home: const SignInScreen(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/homeFromViewVictories':
            return PageTransition<void>(
              child: const HomeScreen(),
              type: PageTransitionType.leftToRightJoined,
              childCurrent: const ViewVictoriesScreen(),
            );
          case '/homeFromSignIn':
            return PageTransition<void>(
              child: const HomeScreen(),
              type: PageTransitionType.fade,
            );
          case '/homeFromPreferences':
            return PageTransition<void>(
              child: const HomeScreen(),
              type: PageTransitionType.leftToRightJoined,
              childCurrent: const PreferencesScreen(),
            );
          case '/preferences':
            return PageTransition<void>(
              child: const PreferencesScreen(),
              type: PageTransitionType.rightToLeftJoined,
              childCurrent: const HomeScreen(),
            );
          case '/push_notifications':
            return PageTransition<void>(
              child: const PushNotificationsScreen(),
              type: PageTransitionType.fade,
            );
          case '/sign_in':
            return PageTransition<void>(
              child: const SignInScreen(),
              type: PageTransitionType.fade,
            );
          case '/view_victories':
            return PageTransition<void>(
              child: const ViewVictoriesScreen(),
              type: PageTransitionType.rightToLeftJoined,
              childCurrent: const HomeScreen(),
            );
          default:
            return PageTransition<void>(
              child: const SignInScreen(),
              type: PageTransitionType.fade,
            );
        }
      },
    );
  }
}
