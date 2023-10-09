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
    pageBackground: Container(color: CustomColours.teal),
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
      'assets/lv_logo_transparent.png',
      alignment: Alignment.center,
    ),
  );

  PageViewModel thirdPageView = PageViewModel(
    pageBackground: Container(color: CustomColours.lightPurple),
    body: const Text(
      'Eating, showering, going for a walk, doing the dishes... All of these are worth celebrating.',
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 22),
    ),
    title: const Text('No Victory is too small'),
    mainImage: Image.asset(
      'assets/lv_logo_transparent.png',
      alignment: Alignment.center,
    ),
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
    ),
  );

  PageViewModel fourthPageView = PageViewModel(
    pageBackground: Container(color: CustomColours.darkPurple),
    body: const Text(
      'Click on the button to begin',
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 22),
    ),
    title: const Text("Let's get started"),
    mainImage: Builder(
      builder: (BuildContext context) => InkWell(
          child: Image.asset(
            'assets/lv_logo_transparent.png',
            alignment: Alignment.center,
          ),
          onTap: () {
            // Set first time setup to true
            SecureStorage().insert(kFirstTimeSetup, 'true');
            // Navigate to sign in screen
            Navigator.pushReplacementNamed(context, '/sign_in');
          }),
    ),
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColours.darkPurple,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                          showSkipButton: false,
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
      ),
    );
  }
}
