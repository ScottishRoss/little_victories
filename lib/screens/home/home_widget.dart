import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:little_victories/screens/home/widgets/first_name_header.dart';
import 'package:little_victories/screens/home/widgets/quick_victory.dart';
import 'package:little_victories/screens/home/widgets/settings_card.dart';
import 'package:little_victories/screens/home/widgets/victories_counter.dart';
import 'package:little_victories/screens/home/widgets/view_victories_card.dart';
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
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
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
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 60.0,
                horizontal: 30.0,
              ),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const FirstNameHeader(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Todo: Remove before release.
                      GestureDetector(
                        onTap: () => widget.callback(3),
                        child: const VictoriesCounter(),
                      ),
                      GestureDetector(
                        onTap: () => widget.callback(1),
                        child: const SettingsCard(),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => widget.callback(2),
                    child: const ViewVictoriesCard(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: QuickVictory(formKey: HomeWidget.formKey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
