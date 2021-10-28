import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/screens/home_screen.dart';
import 'package:little_victories/screens/preferences_screen.dart';
import 'package:little_victories/screens/push_notifications_screen.dart';
import 'package:little_victories/screens/sign_in_screen.dart';
import 'package:little_victories/screens/view_victories_screen.dart';

class NavigationHelper {
  // ignore: avoid_void_async
  void navigateToPreferencesScreen(BuildContext context, User _user) async {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, _, __) {
          return PreferencesScreen(user: _user);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }));
  }

  // ignore: avoid_void_async
  void navigateToPushNotificationsScreen(
      BuildContext context, User _user) async {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, _, __) {
          return PushNotificationsScreen(user: _user);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }));
  }

  // ignore: avoid_void_async
  static void navigateToViewVictoriesScreen(
      BuildContext context, User _user) async {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, _, __) {
          return ViewVictoriesScreen(user: _user);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }));
  }

  // ignore:, avoid_void_async
  void navigateToHomePageScreen(BuildContext context, User _user) async {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, _, __) {
          return HomeScreen(user: _user);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }));
  }

  // ignore: type_annotate_public_apis
  static void navigateToSignInScreen(
    BuildContext context,
  ) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SignInScreen()),
        (Route<dynamic> route) => false);
  }
}
