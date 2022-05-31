import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';

const LinearGradient kTealGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: <Color>[
    CustomColours.lightPurple,
    CustomColours.teal,
  ],
);

const double kModalPadding = 20;
const double kModalAvatarRadius = 45;

bool isDebugMode() {
  return kDebugMode;
}
