import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

import '../../util/constants.dart';
import '../../util/custom_colours.dart';
import '../../util/secure_storage.dart';

// ignore: must_be_immutable
class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);

  void _onIntroEnd(BuildContext context) {
    // Set first time setup to true
    SecureStorage().insert(kFirstTimeSetup, 'true');
    // Set victory counter to 0
    SecureStorage().insert(kVictoryCounter, '0');
    // Navigate to sign in screen
    Navigator.pushReplacementNamed(context, '/sign_in');
  }

  PageViewModel firstPageView = PageViewModel(
    pageBackground: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            CustomColours.darkBlue,
            CustomColours.darkBlue,
            CustomColours.teal,
            CustomColours.hotPink,
          ],
        ),
      ),
    ),
    bubbleBackgroundColor: Colors.white,
    body: const AutoSizeText(
      'Little Victories is here to help you celebrate the small wins in your life',
      style: TextStyle(
        fontSize: 24,
      ),
    ),
    title: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AutoSizeText(
          'Welcome to',
          style: TextStyle(
            fontSize: 24,
            letterSpacing: 1.5,
          ),
        ),
        AutoSizeText(
          'Little Victories',
          style: TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
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
    pageColor: CustomColours.darkBlue,
    bubbleBackgroundColor: CustomColours.peach,
    body: const AutoSizeText(
      'Every time you achieve a small goal, write it down and celebrate it',
      style: TextStyle(
        fontSize: 22,
      ),
    ),
    title: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AutoSizeText(
          'Celebrate your',
          style: TextStyle(
            fontSize: 24,
            letterSpacing: 1.5,
            color: CustomColours.teal,
          ),
        ),
        AutoSizeText(
          'Victories',
          style: TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    ),
    mainImage: Image.asset('assets/lv_logo_transparent.png'),
  );

  PageViewModel thirdPageView = PageViewModel(
    pageColor: CustomColours.teal,
    bubbleBackgroundColor: CustomColours.darkBlue,
    body: const AutoSizeText(
      'Eating, showering, going for a walk, doing the dishes... All of these are worth celebrating',
      style: TextStyle(
        fontSize: 22,
        color: CustomColours.darkBlue,
      ),
    ),
    title: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AutoSizeText(
          'No Victory is too',
          style: TextStyle(
            fontSize: 24,
            letterSpacing: 1.5,
          ),
        ),
        AutoSizeText(
          'small',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: CustomColours.darkBlue,
          ),
        ),
      ],
    ),
    mainImage: Image.asset(
      'assets/lv_logo_transparent.png',
      alignment: Alignment.center,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(builder: (
        BuildContext context,
        BoxConstraints viewportConstraints,
      ) {
        return Container(
          decoration: const BoxDecoration(
            gradient: kBackgroundGradient,
          ),
          child: Builder(
            builder: (BuildContext context) {
              return FadeIn(
                duration: const Duration(seconds: 2),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: IntroViewsFlutter(
                        <PageViewModel>[
                          firstPageView,
                          secondPageView,
                          thirdPageView,
                        ],
                        doneText: AvatarGlow(
                          glowRadiusFactor: 40,
                          glowColor: CustomColours.hotPink,
                          child: const Text(
                            'Start',
                            style: TextStyle(
                              color: CustomColours.darkBlue,
                              fontSize: 24,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        showSkipButton: false,
                        backText: const Text(
                          'Back',
                          style: TextStyle(
                            color: CustomColours.darkBlue,
                            fontSize: 18,
                            letterSpacing: 1.5,
                          ),
                        ),
                        showBackButton: true,
                        onTapDoneButton: () {
                          _onIntroEnd(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
