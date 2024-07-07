import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:little_victories/util/custom_colours.dart';

PageViewModel thirdPageView = PageViewModel(
  decoration: const PageDecoration(
    titleTextStyle: TextStyle(
      color: CustomColours.darkBlue,
    ),
  ),
  body:
      'Eating, showering, going for a walk, doing the dishes... All of these are worth celebrating',
  title: 'No Victory is too small',
  image: Image.asset(
    'assets/lv_logo_transparent.png',
    alignment: Alignment.center,
  ),
);
