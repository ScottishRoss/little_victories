import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:little_victories/util/custom_colours.dart';

PageViewModel firstPageView = PageViewModel(
  pageBackground: Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
      color: CustomColours.darkBlue,
    ),
  ),
  bubbleBackgroundColor: Colors.white,
  body: const AutoSizeText(
    'Little Victories is here to help you celebrate the small wins in your life',
    style: TextStyle(
      fontSize: 24,
    ),
  ),
  title: const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      AutoSizeText(
        'Welcome to',
        style: TextStyle(
          fontSize: 24,
          letterSpacing: 1.5,
        ),
      ),
      AutoSizeText(
        'Little Victories',
        style: TextStyle(
          fontSize: 46,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    ],
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
