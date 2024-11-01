import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:little_victories/screens/intro/widgets/example_list.dart';
import 'package:little_victories/widgets/common/little_victories.dart';
import 'package:little_victories/widgets/common/lv_logo.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';

import '../../util/constants.dart';
import '../../util/custom_colours.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);

  void _onIntroEnd(BuildContext context) {
    // Navigate to sign in screen
    Navigator.pushNamedAndRemoveUntil(
        context, '/sign_in', (Route<dynamic> route) => false);
  }

  final PageViewModel firstPageView = PageViewModel(
    pageColor: CustomColours.darkBlue,
    bubbleBackgroundColor: Colors.white,
    body: AutoSizeText(
      'Celebrate the small wins you have every day',
      style: kBodyTextStyle.copyWith(
        fontSize: 22,
      ),
    ),
    title: const LittleVictories(variant: NameVariant.dark),
    mainImage: const LVLogo(),
  );

  final PageViewModel secondPageView = PageViewModel(
    pageColor: CustomColours.teal,
    bubbleBackgroundColor: Colors.white,
    body: AutoSizeText(
      "We often don't track the many things we do every day that takes effort - and we should!",
      style: kBodyTextStyle.copyWith(
        fontSize: 22,
        color: CustomColours.darkBlue,
      ),
    ),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AutoSizeText(
          'Celebrate your',
          style: kSubtitleStyle.copyWith(fontSize: 22),
        ),
        AutoSizeText(
          'Victories',
          style: kTitleTextStyle.copyWith(
            color: CustomColours.darkBlue,
          ),
        ),
      ],
    ),
    mainImage: const LVLogo(
      variant: LogoVariant.pink,
    ),
  );

  final PageViewModel thirdPageView = PageViewModel(
    pageColor: CustomColours.hotPink,
    bubbleBackgroundColor: Colors.white,
    body: AutoSizeText(
      'Eating, showering, going for a walk... Nothing is too small to celebrate',
      style: kBodyTextStyle.copyWith(
        fontSize: 22,
        color: CustomColours.darkBlue,
      ),
    ),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AutoSizeText(
          'No Victory is too',
          style: kSubtitleStyle.copyWith(fontSize: 22),
          maxFontSize: 100,
        ),
        PlayAnimationBuilder<double>(
          tween: Tween<double>(begin: 100.0, end: 220.0),
          duration: const Duration(seconds: 2),
          builder: (BuildContext context, double value, _) {
            return SizedBox(
              width: value,
              height: 40,
              child: Center(
                child: AutoSizeText(
                  'small',
                  style: kTitleTextStyle.copyWith(
                    color: CustomColours.darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                  minFontSize: 12,
                  maxFontSize: 100,
                ),
              ),
            );
          },
        ),
      ],
    ),
    mainImage: const LVLogo(
      variant: LogoVariant.white,
    ),
  );

  final PageViewModel fourthPageView = PageViewModel(
    pageColor: CustomColours.darkBlue,
    bubbleBackgroundColor: Colors.white,
    mainImage: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const ExampleList(),
    ),
    body: AutoSizeText(
      'Celebrate your victories today',
      style: kSubtitleStyle.copyWith(fontSize: 22),
    ),
    title: const LittleVictories(variant: NameVariant.dark),
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
        return Builder(
          builder: (BuildContext context) {
            return FadeIn(
              duration: const Duration(seconds: 2),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: IntroViewsFlutter(
                      <PageViewModel>[
                        firstPageView,
                        secondPageView,
                        thirdPageView,
                        fourthPageView,
                      ],
                      doneText: AvatarGlow(
                        glowRadiusFactor: 40,
                        repeat: false,
                        glowColor: CustomColours.teal,
                        child: const Text(
                          'start',
                          style: TextStyle(
                            color: CustomColours.hotPink,
                            fontSize: 28,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      columnMainAxisAlignment: MainAxisAlignment.start,
                      showSkipButton: false,
                      showBackButton: false,
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
