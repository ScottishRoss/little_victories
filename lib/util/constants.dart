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

const double kButtonBorderRadius = 5;
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
