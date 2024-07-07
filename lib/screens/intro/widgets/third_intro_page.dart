import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:little_victories/util/custom_colours.dart';

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
