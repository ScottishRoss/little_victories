import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/widgets/home/header.dart';
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
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.white,
                CustomColours.teal,
                CustomColours.hotPink,
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: CustomColours.darkBlue,
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (
                BuildContext context,
                BoxConstraints viewportConstraints,
              ) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                    minWidth: viewportConstraints.maxWidth,
                  ),
                  child: IntrinsicHeight(
                    child: getPage(pageIndex),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget get homeWidget {
    return WillPopScope(
      onWillPop: () async => false,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: const <Widget>[
          Header(),
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
