import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:little_victories/screens/home/widgets/quick_victory.dart';
import 'package:little_victories/util/ad_helper.dart';
import 'package:little_victories/util/custom_colours.dart';

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
                vertical: 40.0,
                horizontal: 20.0,
              ),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Hi Ross!',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 60,
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: CustomColours.peach,
                        ),
                        padding: const EdgeInsets.all(15.0),
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.width / 3,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Victories',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '16',
                              style: TextStyle(
                                fontSize: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(15.0),
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.width / 3,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(
                              Icons.app_settings_alt_outlined,
                              color: Colors.black,
                              size: 60.0,
                            ),
                            Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(15.0),
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.app_settings_alt_outlined,
                          color: Colors.black,
                          size: 60.0,
                        ),
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () => widget.callback(1),
                  //   child: const HomeButtonCard(
                  //     image: 'windows.jpg',
                  //     title: 'Preferences',
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () => widget.callback(2),
                  //   child: const HomeButtonCard(
                  //     image: 'confetti.jpg',
                  //     title: 'Your Victories',
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () => widget.callback(3),
                  //   child: const HomeButtonCard(
                  //     image: 'confetti.jpg',
                  //     title: 'Debug',
                  //   ),
                  // ),

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
