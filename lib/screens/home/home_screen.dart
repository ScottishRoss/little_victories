import 'package:flutter/material.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/widgets/common/custom_button.dart';
import 'package:little_victories/widgets/common/header.dart';
import 'package:little_victories/widgets/common/quick_victory.dart';
import 'package:little_victories/widgets/common/quick_victory_text_field.dart';
import 'package:little_victories/widgets/common/icon_row.dart';
import 'package:little_victories/widgets/common/lv_logo.dart';
import 'package:little_victories/widgets/common/page_body.dart';
import 'package:little_victories/widgets/modals/add_victory_modal.dart';

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
        child: Column(
          children: <Widget>[
            const Header(name: 'Ross'),
            const QuickVictory(),

            CustomButton(
              'Preferences',
              () => Navigator.pushReplacementNamed(
                context,
                '/preferences',
              ),
            ),

            // View Victories
            CustomButton(
              'View your Victories',
              () => Navigator.pushReplacementNamed(
                context,
                '/view_victories',
              ),
            ),
            if (isDebugMode())
              CustomButton(
                'Debug Screen',
                () => Navigator.pushReplacementNamed(
                  context,
                  '/debug',
                ),
              ),

            const Spacer(),
            // Celebrate a Victory
            CustomButton(
              'Celebrate a Victory',
              () => showDialog<Widget>(
                context: context,
                builder: (BuildContext context) {
                  return const AddVictoryBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
