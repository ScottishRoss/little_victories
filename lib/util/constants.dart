import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_colours.dart';

const LinearGradient kTealGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: <Color>[
    CustomColours.lightPurple,
    CustomColours.teal,
  ],
);

const TextStyle kTitleText = TextStyle(
  fontSize: 46,
  fontWeight: FontWeight.w600,
  color: Colors.white,
  height: 0.8,
  letterSpacing: 5.0,
);

const TextStyle kSubtitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const TextStyle kPreferencesItemStyle = TextStyle(
  fontSize: 18,
  letterSpacing: 1.5,
  color: Colors.white,
);

ThemeData kTimePickerDarkTheme = ThemeData.dark().copyWith(
  colorScheme: const ColorScheme.dark(
    primary: CustomColours.darkBlue,
    onPrimary: Colors.white,
    secondary: Colors.white,
    surface: CustomColours.darkBlue,
    onSurface: Colors.white,
  ),
  dialogBackgroundColor: CustomColours.darkBlue,
);

ThemeData kTimePickerLightTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.light(
    secondary: CustomColours.darkBlue,
    primary: CustomColours.darkBlue,
  ),
);

const double kButtonBorderRadius = 20;
const double kModalPadding = 20;
const double kModalAvatarRadius = 45;

const Color kIconRowActiveColour = Colors.white;
const double kiconRowActiveSize = 40;
const Color kIconRowInactiveColour = Colors.white;
const double kIconRowInactiveSize = 25;

bool isDebugMode() {
  return kDebugMode;
}

const String kFirstTimeSetup = 'first_time_setup';
const String kIsNotificationsEnabled = 'is_notifications_enabled';
const String kNotificationTime = 'notification_time';
const String kDefaultNotificationTime = '18:30';

const BoxDecoration kBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      CustomColours.darkPurple,
      CustomColours.teal,
    ],
  ),
  boxShadow: <BoxShadow>[
    BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 10,
    ),
  ],
);

InputDecoration kFormInputDecoration = InputDecoration(
  floatingLabelBehavior: FloatingLabelBehavior.never,
  filled: true,
  fillColor: Colors.white,
  errorStyle: const TextStyle(
    fontSize: 14.0,
    color: Colors.white,
    letterSpacing: 1.25,
  ),
  counterStyle: const TextStyle(
    fontSize: 12.0,
    color: CustomColours.darkBlue,
    letterSpacing: 2.0,
  ),
  prefixIcon: const Icon(
    Icons.person,
    color: CustomColours.darkBlue,
  ),
  labelStyle: const TextStyle(
    fontSize: 18.0,
    color: CustomColours.darkBlue,
    letterSpacing: 2.0,
  ),
  focusColor: CustomColours.darkBlue,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(kButtonBorderRadius),
    borderSide: const BorderSide(
      color: CustomColours.teal,
      width: 2,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(kButtonBorderRadius),
    borderSide: const BorderSide(
      color: Colors.redAccent,
      width: 2,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(kButtonBorderRadius),
    borderSide: const BorderSide(
      color: CustomColours.teal,
      width: 2,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(kButtonBorderRadius),
    borderSide: const BorderSide(
      color: Colors.redAccent,
      width: 2,
    ),
  ),
);
