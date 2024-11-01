import 'dart:developer';

import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/custom_colours.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
    required this.context,
  }) : super(key: key);
  final BuildContext context;

  Future<void> routeAfterSplash() async {
    // If it is the first time, go to intro screen.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final bool _isUserSignedIn = Authentication().isUserSignedIn();
        if (_isUserSignedIn) {
          // If a user is signed in, go to home page.
          log('Splash: Navigating to home');
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', (Route<dynamic> route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/intro', (Route<dynamic> route) => false);
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
          await routeAfterSplash();
        }
      },
      childWidget: Image.asset('assets/logo.png'),
    );
  }
}
