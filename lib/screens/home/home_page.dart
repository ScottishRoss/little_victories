import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/data/firestore_operations/firestore_victories.dart';
import 'package:little_victories/main.dart';
import 'package:little_victories/screens/home/debug_screen.dart';
import 'package:little_victories/screens/home/home_widget.dart';
import 'package:little_victories/screens/preferences/preferences_widget.dart';
import 'package:little_victories/screens/view_victories/view_victories_widget.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/widgets/common/header_placeholder.dart';
import 'package:little_victories/widgets/common/page_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late FToast fToast;

  // Data streams
  late Future<AggregateQuerySnapshot> _victoriesData;

  void _updatePageIndex(int pageIndex) {
    setState(() => _pageIndex = pageIndex);
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
    NotificationsService().showNotificationsConsentIfNeeded();

    // Get data
    _victoriesData = getVictoriesAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const HeaderPlaceholder(),
          getPage(_pageIndex),
        ],
      ),
    );
  }
}
