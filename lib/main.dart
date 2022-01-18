import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/screens/preferences_screen.dart';
import 'package:little_victories/screens/push_notifications_screen.dart';
import 'package:little_victories/screens/view_victories_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final User? _user = FirebaseAuth.instance.currentUser;

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
      home: _user != null ? HomeScreen(user: _user!) : const SignInScreen(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/homeFromViewVictories':
            return PageTransition<void>(
              child: HomeScreen(user: _user!),
              type: PageTransitionType.leftToRightJoined,
              childCurrent: ViewVictoriesScreen(user: _user!),
            );
          case '/homeFromSignIn':
            return PageTransition<void>(
              child: HomeScreen(user: _user!),
              type: PageTransitionType.fade,
            );
          case '/homeFromPreferences':
            return PageTransition<void>(
              child: HomeScreen(user: _user!),
              type: PageTransitionType.leftToRightJoined,
              childCurrent: PreferencesScreen(user: _user!),
            );
          case '/preferences':
            return PageTransition<void>(
              child: PreferencesScreen(user: _user!),
              type: PageTransitionType.rightToLeftJoined,
              childCurrent: HomeScreen(user: _user!),
            );
          case '/push_notifications':
            return PageTransition<void>(
              child: PushNotificationsScreen(user: _user!),
              type: PageTransitionType.fade,
            );
          case '/sign_in':
            return PageTransition<void>(
              child: const SignInScreen(),
              type: PageTransitionType.fade,
            );
          case '/view_victories':
            return PageTransition<void>(
              child: ViewVictoriesScreen(user: _user!),
              type: PageTransitionType.rightToLeftJoined,
              childCurrent: HomeScreen(user: _user!),
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
