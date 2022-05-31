import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/screens/preferences_screen.dart';
import 'package:little_victories/screens/push_notifications_screen.dart';
import 'package:little_victories/screens/view_victories_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'res/notifications_service.dart';
import 'screens/debug_screen.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationsService().init();
  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );
  await Firebase.initializeApp();

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (BuildContext context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        highlightColor: CustomColours.lightPurple,
      ),
      home: const SignInScreen(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
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
