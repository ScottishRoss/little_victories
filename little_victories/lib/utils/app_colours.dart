import 'dart:math';
import 'package:flutter/material.dart';

Random random = Random();
int colourIndex = 0;

// ignore: avoid_classes_with_only_static_members
class AppColours {
  static const Color darkPurple = Color(0xff3b1777);
  static const Color lightPurple = Color(0xff8060c3);
  static const Color teal = Color(0xff7fc7df);

  static final List<Color> customColoursList = [darkPurple, lightPurple, teal];
}

Color getRandomColor() {
  final list = AppColours.customColoursList;
  final _random = Random();
  final colour = list[_random.nextInt(list.length)];

  return colour;
}
