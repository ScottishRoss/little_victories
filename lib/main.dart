import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_victories/data/firestore_operations.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/screens/home/debug_screen.dart';
import 'package:little_victories/screens/home/home_screen.dart';
import 'package:little_victories/screens/home/view_victories_screen.dart';
import 'package:little_victories/screens/intro/intro_screen.dart';
import 'package:little_victories/screens/preferences/preferences_screen.dart';
import 'package:little_victories/screens/preferences/push_notifications_screen.dart';
import 'package:little_victories/screens/sign_in/sign_in_screen.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/util/secure_storage.dart';
import 'package:page_transition/page_transition.dart';

Future<Widget> routeOnFirstTimeSetup() async {
  final String? _isFirstTime =
      await SecureStorage().getFromKey(kFirstTimeSetup);
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

  AwesomeNotifications().actionStream.listen((ReceivedAction event) {
    if (event.buttonKeyPressed == 'debug_victory') {
      final User? _user = FirebaseAuth.instance.currentUser;
      final String _textInput = event.buttonKeyInput.toString();

      saveLittleVictoryFromNotification(_user!, _textInput);
    }
  });

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  final Widget app = await routeOnFirstTimeSetup();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (BuildContext context) => MyApp(route: app),
    ),
  );
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
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
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
