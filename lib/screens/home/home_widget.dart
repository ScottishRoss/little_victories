import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:little_victories/data/firestore_operations/firestore_notifications.dart';
import 'package:little_victories/screens/home/widgets/home_button_card.dart';
import 'package:little_victories/screens/home/widgets/quick_victory.dart';
import 'package:little_victories/util/ad_helper.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final ValueChanged<int> callback;
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    setNotificationsForExistingUsers();
    BannerAd(
      adUnitId: AdHelper.getAdIdByType(AdType.banner),
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError err) {
          log('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Expanded(
        child: Stack(
          children: <Widget>[
            if (_bannerAd != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            ListView(
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                QuickVictory(formKey: HomeWidget.formKey),
                GestureDetector(
                  onTap: () => widget.callback(1),
                  child: const HomeButtonCard(
                    image: 'person-phone.jpg',
                    title: 'Preferences',
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.callback(2),
                  child: const HomeButtonCard(
                    image: 'person-meditating.jpg',
                    title: 'Your Victories',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
