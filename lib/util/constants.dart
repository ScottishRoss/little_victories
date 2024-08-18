import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_colours.dart';

const LinearGradient kBackgroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: <Color>[
    CustomColours.darkBlue,
    CustomColours.darkBlue,
    CustomColours.teal,
    CustomColours.hotPink,
    CustomColours.hotPink,
  ],
);

const TextStyle kTitleTextStyle = TextStyle(
  fontSize: 46,
  color: Colors.white,
  height: 0.8,
  letterSpacing: 5.0,
);

const TextStyle kBodyTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
);

TextStyle kSubtitleStyle = kBodyTextStyle.copyWith(letterSpacing: 2.0);

TextStyle kSubtitleStyleBold =
    kSubtitleStyle.copyWith(fontWeight: FontWeight.bold);

const TextStyle kPreferencesItemStyle = TextStyle(
  fontSize: 18,
  letterSpacing: 1.5,
  color: Colors.white,
);

ThemeData kTimePickerDarkTheme = ThemeData.dark().copyWith(
  colorScheme: const ColorScheme.dark(
    primary: CustomColours.darkBlue,
    secondary: CustomColours.hotPink,
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

const Color kIconRowActiveColour = CustomColours.teal;
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
