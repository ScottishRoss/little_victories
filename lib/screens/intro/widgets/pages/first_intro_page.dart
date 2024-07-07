import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:little_victories/util/custom_colours.dart';

PageViewModel firstPageView = PageViewModel(
  decoration: const PageDecoration(
    titleTextStyle: TextStyle(
      color: CustomColours.darkBlue,
    ),
  ),
  body:
      'Little Victories is here to help you celebrate the small wins in your life',
  title: 'Welcome to Little Victories',
  image: Image.asset(
    'assets/lv_logo_transparent.png',
    alignment: Alignment.center,
  ),
);
