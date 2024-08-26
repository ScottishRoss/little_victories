import 'dart:async';
import 'dart:developer';

import 'package:dotenv/dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:little_victories/data/firestore_operations/firestore_account.dart';
import 'package:little_victories/firebase_options.dart';
import 'package:little_victories/screens/home/home_page.dart';
import 'package:little_victories/screens/misc/set_display_name.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/util/secure_storage.dart';
import 'package:page_transition/page_transition.dart';

import 'screens/intro/intro_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';

Future<bool> isFirstTime() async {
  final String? _isFirstTime =
      await SecureStorage().getFromKey(kFirstTimeSetup);
  log('_isFirstTime = $_isFirstTime');
  if (_isFirstTime == null) {
    return true;
  } else {
    return false;
  }
}

Future<Widget> routeOnAppLaunch(bool isFirstTime) async {
  // If it is the first time, go to intro screen.
  if (isFirstTime) {
    return IntroScreen();
  } else {
    // If it is not the first time, check to see if user is signed in.
    final bool _isUserSignedIn = Authentication().isUserSignedIn();
    if (_isUserSignedIn) {
      // If a user is signed in, go to home page.
      return const HomePage();
    } else {
      // If a user is not signed in, go to sign in page.
      return const SignInScreen();
    }
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

Future<void> initialiseAdCounter(bool isFirstTime) async {
  if (!isFirstTime) {
    initAdCounter();
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // Ensure everything is initialised.
  WidgetsFlutterBinding.ensureInitialized();

  // // Get env variables
  // final DotEnv env = DotEnv(includePlatformEnvironment: true)..load();

  // Check to see if it's the first time the app has been launched.
  final bool _isFirstTime = await isFirstTime();

  // Initialise Firebase first.
  log('Initializing Firebase');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Then initialise Google Ads
  log('Initializing MobileAds');
  await MobileAds.instance.initialize().then((_) async {
    await initialiseAdCounter(_isFirstTime);
  });

  // Finally initialise notifications.
  log('Initializing NotificationsService');
  NotificationsService().init();

  // Prevent the device from going landscape.
  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );

  // Get the page to route to.
  final Widget app = await routeOnAppLaunch(_isFirstTime);
  runApp(MyApp(route: app));
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
        hintColor: CustomColours.teal, // Character Counter Colour
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(),
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
