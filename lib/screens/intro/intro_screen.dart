import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

import 'package:introduction_screen/introduction_screen.dart';

import 'package:little_victories/screens/intro/widgets/pages/first_intro_page.dart';
import 'package:little_victories/screens/intro/widgets/pages/second_intro_page.dart';
import 'package:little_victories/screens/intro/widgets/pages/third_intro_page.dart';

import '../../util/constants.dart';
import '../../util/secure_storage.dart';

// ignore: must_be_immutable
class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  void _onIntroEnd(BuildContext context) {
    // Set first time setup to true
    SecureStorage().insert(kFirstTimeSetup, 'true');
    // Set victory counter to 0
    SecureStorage().insert(kVictoryCounter, '0');
    // Navigate to sign in screen
    Navigator.pushReplacementNamed(context, '/sign_in');
  }

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
        return Builder(
          builder: (BuildContext context) {
            return FadeIn(
              duration: const Duration(seconds: 2),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: IntroductionScreen(
                      pages: <PageViewModel>[
                        firstPageView,
                        secondPageView,
                        thirdPageView,
                      ],
                      showSkipButton: true,
                      showNextButton: false,
                      skip: const Text('Skip'),
                      done: const Text('Done'),
                      onDone: () {
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
        );
      }),
    );
  }
}
