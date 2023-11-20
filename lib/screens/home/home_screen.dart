import 'package:flutter/material.dart';
import 'package:little_victories/widgets/home/home_button_card.dart';
import 'package:little_victories/widgets/home/quick_victory.dart';

import '../../util/authentication.dart';
import '../../util/notifications_service.dart';
import '../../widgets/common/page_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: unused_field
  final NotificationsService _notificationsService = NotificationsService();
  @override
  void initState() {
    super.initState();
    Authentication().authCheck(context);
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: PopScope(
        canPop: false,
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * .20),
            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
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
            ),
          ],
        ),
      ),
    );
  }
}
