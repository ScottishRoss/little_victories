import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:little_victories/screens/home/home_page.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/util/secure_storage.dart';
import 'package:page_transition/page_transition.dart';

import 'screens/intro/intro_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';

Future<Widget> routeOnFirstTimeSetup() async {
  final String? _isFirstTime =
      await SecureStorage().getFromKey(kFirstTimeSetup);
  log('isFirstTime: $_isFirstTime');
  if (_isFirstTime != null) {
    return const SignInScreen();
  } else {
    return IntroScreen();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  NotificationsService().init();
  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );
  await Firebase.initializeApp();

  final Widget app = await routeOnFirstTimeSetup();

  runApp(const MyApp(route: SignInScreen()));

  //FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.route,
  }) : super(key: key);

  final Widget route;

  // ignore: avoid_field_initializers_in_const_classes
  final SnackBar snackbar = const SnackBar(
    backgroundColor: CustomColours.lightPurple,
    content: Text(
      'Tap back again to leave',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Little Victories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: CustomColours.newDarkPurple, // Character Counter Colour
        colorScheme: const ColorScheme.dark(
          primary: CustomColours.teal,
          secondary: CustomColours.darkBlue,
          error: Colors.black,
        ),
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(),
        highlightColor: CustomColours.lightPurple,
        timePickerTheme: TimePickerThemeData(
          backgroundColor: CustomColours.teal,
          hourMinuteTextColor: CustomColours.darkPurple,
          entryModeIconColor: CustomColours.darkPurple,
          dayPeriodTextColor: CustomColours.darkPurple,
          dayPeriodBorderSide: const BorderSide(
            color: CustomColours.darkPurple,
          ),
          dialHandColor: CustomColours.darkPurple,
          dialTextColor: CustomColours.darkPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hourMinuteShape: const CircleBorder(),
          helpTextStyle: const TextStyle(color: CustomColours.darkPurple),
        ),
      ),
      home: route,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/intro':
            return PageTransition<void>(
              child: IntroScreen(),
              type: PageTransitionType.fade,
            );
          case '/home':
            return PageTransition<void>(
              child: const HomePage(),
              type: PageTransitionType.fade,
            );

          case '/sign_in':
            return PageTransition<void>(
              child: const SignInScreen(),
              type: PageTransitionType.fade,
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
