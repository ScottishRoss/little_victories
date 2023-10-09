import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/screens/home/debug_screen.dart';
import 'package:little_victories/screens/home/home_screen.dart';
import 'package:little_victories/screens/intro/intro_screen.dart';
import 'package:little_victories/screens/preferences/preferences_screen.dart';
import 'package:little_victories/screens/preferences/push_notifications_screen.dart';
import 'package:little_victories/screens/sign_in/sign_in_screen.dart';
import 'package:little_victories/screens/view_victories/view_victories_screen.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/util/secure_storage.dart';
import 'package:page_transition/page_transition.dart';

Future<Widget> routeOnFirstTimeSetup() async {
  final String? _isFirstTime =
      await SecureStorage().getFromKey(kFirstTimeSetup);
  print(_isFirstTime);
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

  runApp(MyApp(route: app));

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
        primarySwatch: buildMaterialColor(CustomColours.darkPurple),
        primaryColor: CustomColours.darkPurple,
        secondaryHeaderColor: CustomColours.darkPurple,
        hintColor: CustomColours.darkPurple,
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
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
              child: const HomeScreen(),
              type: PageTransitionType.fade,
            );
          case '/debug':
            return PageTransition<void>(
              child: const DebugScreen(),
              type: PageTransitionType.fade,
            );
          case '/preferences':
            return PageTransition<void>(
              child: const PreferencesScreen(),
              type: PageTransitionType.fade,
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
