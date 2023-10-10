import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/secure_storage.dart';

// ignore: must_be_immutable
class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);

  void _onIntroEnd(BuildContext context) {
    // Set first time setup to true
    SecureStorage().insert(kFirstTimeSetup, 'true');
    // Navigate to sign in screen
    Navigator.pushReplacementNamed(context, '/sign_in');
  }

  PageViewModel firstPageView = PageViewModel(
    pageColor: CustomColours.darkPurple,
    bubbleBackgroundColor: Colors.white,
    body: const Text(
      'Little Victories is here to help you celebrate the small wins in life.',
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 22),
    ),
    title: const Text(
      'Welcome to Little Victories',
    ),
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 42,
    ),
    mainImage: Image.asset(
      'assets/lv_logo_transparent.png',
      alignment: Alignment.center,
    ),
  );

  PageViewModel secondPageView = PageViewModel(
    pageColor: CustomColours.teal,
    bubbleBackgroundColor: Colors.white,
    body: const Text(
      'Every time you achieve a small goal, keep a note of it in here. No Victory is too small.',
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 22,
        color: CustomColours.darkPurple,
      ),
    ),
    title: const Text(
      'Celebrate your Victories',
      style: TextStyle(
        color: CustomColours.darkPurple,
        fontWeight: FontWeight.bold,
      ),
    ),
    mainImage: Image.asset(
      'assets/lv_logo_transparent_dark_purple.png',
      alignment: Alignment.center,
    ),
  );

  PageViewModel thirdPageView = PageViewModel(
    pageColor: Colors.black26,
    bubbleBackgroundColor: Colors.white,
    body: const Text(
      'Eating, showering, going for a walk, doing the dishes... All of these are worth celebrating.',
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 22,
        color: CustomColours.teal,
      ),
    ),
    title: const Text(
      'No Victory is too small',
      style: TextStyle(color: CustomColours.teal),
    ),
    mainImage: Image.asset(
      'assets/lv_logo_transparent_teal.png',
      alignment: Alignment.center,
    ),
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(builder: (
        BuildContext context,
        BoxConstraints viewportConstraints,
      ) {
        return Builder(
          builder: (BuildContext context) {
            return FadeIn(
              duration: const Duration(seconds: 2),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: IntroViewsFlutter(<PageViewModel>[
                      firstPageView,
                      secondPageView,
                      thirdPageView,
                    ],
                        doneText: const AvatarGlow(
                          endRadius: 40,
                          glowColor: CustomColours.teal,
                          child: Text('Start'),
                        ),
                        showSkipButton: false,
                        backText: const Text('Back'),
                        showBackButton: true,
                        pageButtonTextStyles: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ), onTapDoneButton: () {
                      _onIntroEnd(context);
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
