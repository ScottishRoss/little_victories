import 'dart:developer';
import 'dart:io';

import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/secure_storage.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
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

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  Future<void> incrementAdCounter() async {
    final String? adCounter = await SecureStorage().getFromKey(kVictoryCounter);
    int counter = int.parse(adCounter ?? '0');
    counter++;
    await SecureStorage().insert(kVictoryCounter, counter.toString());
    log('Ad counter incremented to $counter');
  }

  Future<int> getAdCounter() async {
    final String? adCounter = await SecureStorage().getFromKey(kVictoryCounter);
    final int counter = int.parse(adCounter ?? '0');

    log('Ad counter is $counter');
    return counter;
  }

  Future<void> resetAdCounter() async {
    await SecureStorage().insert(kVictoryCounter, '0');
    log('Ad counter reset to 0');
  }
}
