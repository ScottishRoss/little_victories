import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:little_victories/data/firestore_operations/firestore_notifications.dart';
import 'package:little_victories/main.dart';
import 'package:little_victories/screens/home/debug_screen.dart';
import 'package:little_victories/screens/home/home_widget.dart';
import 'package:little_victories/screens/preferences/preferences_widget.dart';
import 'package:little_victories/screens/view_victories/view_victories_widget.dart';
import 'package:little_victories/util/ad_helper.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/widgets/common/custom_toast.dart';
import 'package:little_victories/widgets/common/header_placeholder.dart';
import 'package:little_victories/widgets/common/page_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // ignore: unused_field
  final NotificationsService _notificationsService = NotificationsService();

  late FToast fToast;

  BannerAd? _bannerAd;

  // ignore: unused_element
  void _showToast(String message) {
    fToast.showToast(
      child: CustomToast(message: message),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  // ignore: unused_element
  void _removeToast() {
    fToast.removeCustomToast();
  }

  void _updatePageIndex(int pageIndex) {
    setState(() => _pageIndex = pageIndex);
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  late int _pageIndex = 0;
  Widget getPage(int index) {
    switch (index) {
      case 0:
        log('Page: Home');
        return HomeWidget(callback: _updatePageIndex);
      case 1:
        log('Page: Preferences');
        return PreferencesWidget(callback: _updatePageIndex);
      case 2:
        log('Page: View Victories');
        return ViewVictoriesWidget(callback: _updatePageIndex);
      case 3:
        log('Page: Debug');
        return const DebugScreen();
      case 4:
        log('Page: TBC');
        return const Placeholder();

      default:
        log('Page: Home');
        return HomeWidget(callback: _updatePageIndex);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
    fToast = FToast();
    fToast.init(navigatorKey.currentContext!);
    log('Page Index = $_pageIndex');
    setNotificationsForExistingUsers();

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
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Stack(
        children: <Widget>[
          if (_bannerAd != null)
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const HeaderPlaceholder(),
              getPage(_pageIndex),
            ],
          ),
        ],
      ),
    );
  }
}
