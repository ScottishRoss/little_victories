import 'dart:math';
import 'package:flutter/material.dart';

Random random = Random();
int colourIndex = 0;

// ignore: avoid_classes_with_only_static_members
class CustomColours {
  static const Color googleBackground = Color(0xFF4285F4);
  static const Color darkPurple = Color(0xff3b1777);
  static const Color lightPurple = Color(0xff8060c3);
  static const Color teal = Color(0xff7fc7df);

  static final List<Color> customColoursList = <Color>[
    darkPurple,
    lightPurple,
    teal,
  ];
}

Color getRandomColor() {
  final List<Color> list = CustomColours.customColoursList;
  final Random _random = Random();
  final Color colour = list[_random.nextInt(list.length)];

  return colour;
}

MaterialColor buildMaterialColor(Color color) {
  final List<double> strengths = <double>[.05];
  final Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final double strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
