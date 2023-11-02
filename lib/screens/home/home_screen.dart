import 'package:flutter/material.dart';
import 'package:little_victories/widgets/home/home_buttons.dart';
import 'package:little_victories/widgets/home/quick_victory.dart';

import '../../util/authentication.dart';
import '../../util/notifications_service.dart';
import '../../widgets/common/page_body.dart';
import '../../widgets/home/header.dart';

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
      child: WillPopScope(
        onWillPop: () async => false,
        child: const Column(
          children: <Widget>[
            Header(),
            QuickVictory(),
            HomeButtons(),
          ],
        ),
      ),
    );
  }
}
