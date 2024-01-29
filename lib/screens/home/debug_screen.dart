import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:little_victories/util/ad_helper.dart';

import '../../util/authentication.dart';
import '../../util/notifications_service.dart';
import '../../util/secure_storage.dart';
import '../../widgets/common/custom_button.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  _DebugScreenState createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback =
              FullScreenContentCallback<InterstitialAd>(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              Navigator.pushReplacementNamed(context, '/home');
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (LoadAdError err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  final SecureStorage _secureStorage = SecureStorage();
  @override
  void initState() {
    Authentication().authCheck(context);
    _loadInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          CustomButton('Load Ad', () {
            if (_interstitialAd != null) {
              _interstitialAd?.show();
            } else {
              log('Interstitial ad is still loading...');
            }
          }),
          CustomButton(
            'Intro screen',
            () => Navigator.pushReplacementNamed(context, '/intro'),
          ),
          CustomButton(
            'Fire Notification',
            () => NotificationsService().fireNotification(),
          ),
          CustomButton(
            'Cleardown',
            () {
              _secureStorage.deleteAll();
              Authentication.signOutOfGoogle(context: context);
            },
          ),
          CustomButton(
            'List Notifications',
            () async {
              final List<dynamic> notifications =
                  await AwesomeNotifications().listScheduledNotifications();
              print(notifications);
            },
          ),
          CustomButton('Log secure storage', () async {
            final Map<String, String>? _secureStorageData =
                await _secureStorage.getAll();

            for (final MapEntry<String, String> item
                in _secureStorageData!.entries) {
              log(item.toString());
            }
          }),
          CustomButton(
            'Back',
            () => Navigator.pushNamed(
              context,
              '/home',
            ),
          ),
          CustomButton(
            'Set Display Name',
            () => Navigator.pushNamed(
              context,
              '/display_name',
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
