import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';

const String kFacebookAppId = '1096908177639475';

const LinearGradient kTealGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: <Color>[
    CustomColours.lightPurple,
    CustomColours.teal,
  ],
);

const TextStyle kSubtitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const double kModalPadding = 20;
const double kModalAvatarRadius = 45;

bool isDebugMode() {
  return kDebugMode;
}

const String kFirstTimeSetup = 'first_time_setup';
const String kIsNotificationsEnabled = 'is_notifications_enabled';
const String kNotificationTime = 'notification_time';

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
