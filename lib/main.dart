import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:little_victories/data/firestore_operations/firestore_account.dart';
import 'package:little_victories/firebase_options.dart';
import 'package:little_victories/screens/home/home_page.dart';
import 'package:little_victories/splash_screen.dart';
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
  if (_isFirstTime == null) {
    log('_isFirstTime = true');
    return true;
  } else {
    log('_isFirstTime = false');
    return false;
  }
}

Future<void> initialiseAdCounter(bool isFirstTime) async {
  if (isFirstTime) {
    initAdCounter();
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // Ensure everything is initialised.
  WidgetsFlutterBinding.ensureInitialized();

  // init cache
  final DefaultCacheManager cache = DefaultCacheManager();

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
  NotificationsService().initialise();

  // Prevent the device from going landscape.
  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );

  runApp(
    MyApp(
      isFirstTime: _isFirstTime,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.isFirstTime,
  }) : super(key: key);

  final bool isFirstTime;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      title: 'Little Victories',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: CustomColours.teal,

        hintColor: CustomColours.teal, // Character Counter Colour
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Builder(
        builder: (BuildContext context) {
          return Center(
            child: SplashScreen(
              isFirstTime: isFirstTime,
              context: context,
            ),
          );
        },
      ),
      onGenerateRoute: (RouteSettings settings) {
        const Duration _duration = Duration(milliseconds: 1000);
        switch (settings.name) {
          case '/intro':
            return PageTransition<void>(
              child: IntroScreen(),
              type: PageTransitionType.fade,
              duration: _duration,
            );
          case '/home':
            return PageTransition<void>(
              child: const HomePage(),
              type: PageTransitionType.fade,
              duration: _duration,
            );

          case '/sign_in':
            return PageTransition<void>(
              child: const SignInScreen(),
              type: PageTransitionType.fade,
              duration: _duration,
            );

          default:
            return PageTransition<void>(
              child: SplashScreen(context: context),
              type: PageTransitionType.fade,
              duration: _duration,
            );
        }
      },
    );
  }
}
