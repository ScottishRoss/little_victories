import 'dart:io';

import 'package:little_victories/util/constants.dart';

// ignore: avoid_classes_with_only_static_members
class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7100257291492276/1487516572';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get testAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String getAdIdByType(AdType type) {
    final bool _isDebugMode = isDebugMode();
    if (_isDebugMode) {
      switch (type) {
        case AdType.banner:
          return bannerAdUnitId;

        case AdType.interstitial:
          return interstitialAdUnitId;

        default:
          return testAdUnitId;
      }
    } else {
      return testAdUnitId;
    }
  }
}

enum AdType { banner, interstitial }
