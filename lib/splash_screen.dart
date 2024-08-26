import 'dart:developer';

import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/custom_colours.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
    this.isFirstTime = false,
    required this.context,
  }) : super(key: key);

  final bool isFirstTime;
  final BuildContext context;

  Future<void> routeAfterSplash(bool isFirstTime) async {
    // If it is the first time, go to intro screen.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (isFirstTime) {
          log('Splash: Navigating to intro');
          Navigator.pushNamedAndRemoveUntil(
              context, '/intro', (Route<dynamic> route) => false);
        } else {
          // If it is not the first time, check to see if user is signed in.
          final bool _isUserSignedIn = Authentication().isUserSignedIn();
          if (_isUserSignedIn) {
            // If a user is signed in, go to home page.
            log('Splash: Navigating to home');
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (Route<dynamic> route) => false);
          } else {
            // If a user is not signed in, go to sign in page.
            log('Splash: Navigating to sign in');
            Navigator.pushNamedAndRemoveUntil(
                context, '/sign_in', (Route<dynamic> route) => false);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      useImmersiveMode: true,
      backgroundColor: CustomColours.darkBlue,
      asyncNavigationCallback: () async {
        await Future<dynamic>.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          await routeAfterSplash(isFirstTime);
        }
      },
      childWidget: Image.asset('assets/logo.png'),
    );
  }
}
