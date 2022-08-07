// ignore_for_file: avoid_field_initializers_in_const_classes

import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/secure_storage.dart';
import 'package:little_victories/widgets/common/page_body.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);

  final List<PageViewModel> pages = <PageViewModel>[
    PageViewModel(
      pageBackground: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: <double>[0.0, 1.0],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated,
            colors: <Color>[
              CustomColours.darkPurple,
              CustomColours.teal,
            ],
          ),
        ),
      ),
      body: const Text(
        'Little Victories has been designed to help you celebrate the Little Victories you have each day.',
      ),
      title: const Text(
        'Welcome to Little Victories',
      ),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: const TextStyle(color: Colors.white),
      mainImage: Image.asset(
        'assets/lv_logo_transparent.png',
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      pageBackground: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: <double>[0.0, 1.0],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated,
            colors: <Color>[
              CustomColours.darkPurple,
              CustomColours.lightPurple,
            ],
          ),
        ),
      ),
      body: const Text(
        'Every time you achieve a small goal, keep a note of it in here. No Victory is too small to celebrate!',
      ),
      title: const Text('Celebrate your Victories'),
      mainImage: Image.asset(
        'assets/lv_logo_transparent.png',
        alignment: Alignment.center,
      ),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: const TextStyle(color: Colors.white),
    ),
    PageViewModel(
      pageBackground: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: <double>[0.0, 1.0],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated,
            colors: <Color>[
              CustomColours.teal,
              CustomColours.darkPurple,
            ],
          ),
        ),
      ),
      body: const Text(
        'Remembering to eat, having a shower, going for a walk, doing the dishes, etc... All of these are worth celebrating.',
      ),
      title: const Text('No Victory is too small!'),
      mainImage: Image.asset(
        'assets/lv_logo_transparent.png',
        alignment: Alignment.center,
      ),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: const TextStyle(color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Builder(
        builder: (BuildContext context) => IntroViewsFlutter(
          pages,
          showNextButton: true,
          showBackButton: true,
          pageButtonTextStyles: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          onTapDoneButton: () {
            Navigator.pushReplacementNamed(
              context,
              '/home',
            );
          },
        ),
      ),
    );
  }
}
