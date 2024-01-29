import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class CustomColours {
  static const Color teal = Color(0xff80bfce);
  static const Color pink = Color(0xffe8a2fa);
  static const Color peach = Color(0xffffd4c4);
  static const Color brightPurple = Color(0xff9334aa);
  static const Color mediumPurple = Color(0xff9777e6);
  static const Color hotPink = Color(0xFFeb7ba8);
  static const Color darkBlue = Color(0xff0b1524);
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
