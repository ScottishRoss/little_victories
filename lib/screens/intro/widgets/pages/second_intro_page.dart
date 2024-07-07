import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:little_victories/util/custom_colours.dart';

PageViewModel secondPageView = PageViewModel(
  decoration: const PageDecoration(
    titleTextStyle: TextStyle(
      color: CustomColours.darkBlue,
    ),
  ),
  body: 'Every time you achieve a small goal, write it down and celebrate it',
  title: 'Celebrate your Victories',
  image: Image.asset(
    'assets/lv_logo_transparent.png',
    alignment: Alignment.center,
  ),
);
