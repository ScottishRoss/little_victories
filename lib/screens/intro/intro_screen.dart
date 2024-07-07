import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:little_victories/screens/intro/widgets/buttons/intro_back_button.dart';
import 'package:little_victories/screens/intro/widgets/buttons/intro_start_button.dart';
import 'package:little_victories/screens/intro/widgets/first_intro_page.dart';
import 'package:little_victories/screens/intro/widgets/second_intro_page.dart';
import 'package:little_victories/screens/intro/widgets/third_intro_page.dart';

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
                    child: IntroViewsFlutter(
                      <PageViewModel>[
                        firstPageView,
                        secondPageView,
                        thirdPageView,
                      ],
                      doneText: const IntroStartButton(),
                      showSkipButton: false,
                      backText: const IntroBackButton(),
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
        );
      }),
    );
  }
}
