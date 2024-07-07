import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:little_victories/util/custom_colours.dart';

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
