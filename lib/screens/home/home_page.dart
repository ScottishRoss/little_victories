import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:little_victories/widgets/common/header_placeholder.dart';
import 'package:little_victories/widgets/common/page_body.dart';
import 'package:little_victories/widgets/home/home_button_card.dart';
import 'package:little_victories/widgets/home/quick_victory.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late int pageIndex = 0;
  Widget getPage(int index) {
    switch (index) {
      case 0:
        return homeWidget;
      case 1:
        return const Placeholder();
      case 2:
        return const Placeholder();
      case 3:
        return const Placeholder();
      case 4:
        return const Placeholder();

      default:
        return const Placeholder();
    }
  }

  @override
  void initState() {
    super.initState();
    pageIndex = 0;
    log(pageIndex.toString());
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        children: <Widget>[
          const HeaderPlaceholder(),
          getPage(pageIndex),
        ],
      ),
    );
  }

  Widget get homeWidget {
    return PopScope(
      canPop: false,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: const <Widget>[
          QuickVictory(),
          HomeButtonCard(
            image: 'windows.jpg',
            title: 'Preferences',
            route: '/preferences',
          ),
          HomeButtonCard(
            image: 'confetti.jpg',
            title: 'Your Victories',
            route: '/view_victories',
          ),
        ],
      ),
    );
  }
}
