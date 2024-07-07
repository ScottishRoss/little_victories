import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:little_victories/screens/home/home_page.dart';
import 'package:little_victories/screens/misc/set_display_name.dart';
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
    return const IntroScreen();
  }
}

Future<void> insertDefaultNotificationTime() async {
  final String? _notificationTime =
      await SecureStorage().getFromKey(kNotificationTime);
  log('notificationTime: $_notificationTime');
  if (_notificationTime == null) {
    await SecureStorage().insert(kNotificationTime, kDefaultNotificationTime);
    log('Inserted default notification time');
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  log('Initializing MobileAds');
  MobileAds.instance.initialize();
  log('Initializing NotificationsService');
  NotificationsService().init();
  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );
  log('Initializing Firebase');
  await Firebase.initializeApp();
  log('Inserting default notification time');
  insertDefaultNotificationTime();

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      title: 'Little Victories',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: CustomColours.darkBlue, // Character Counter Colour
        colorScheme: const ColorScheme.dark(
          primary: CustomColours.teal,
          secondary: CustomColours.darkBlue,
          error: Colors.black,
        ),
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: route,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/intro':
            return PageTransition<void>(
              child: const IntroScreen(),
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

          case '/display_name':
            return PageTransition<void>(
              child: const DisplayName(),
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
