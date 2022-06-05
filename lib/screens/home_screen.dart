import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/common/lv_logo.dart';
import 'package:little_victories/widgets/common/page_body.dart';
import 'package:little_victories/widgets/modals/add_victory_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Authentication().authCheck(context);
    NotificationsService().showNotificationModal(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Column(
          children: <Widget>[
            const LVLogo(),
            const Spacer(),
            buildNiceButton(
              'Preferences',
              CustomColours.darkPurple,
              () => Navigator.pushNamed(
                context,
                '/preferences',
              ),
            ),

            // View Victories
            buildNiceButton(
              'View your Victories',
              CustomColours.darkPurple,
              () => Navigator.pushNamed(
                context,
                '/view_victories',
              ),
            ),

            // buildNiceButton(
            //   'Debug Screen',
            //   CustomColours.darkPurple,
            //   () => Navigator.pushNamed(
            //     context,
            //     '/debug',
            //   ),
            // ),
            const Spacer(),
            // Celebrate a Victory
            buildNiceButton(
              'Celebrate a Victory',
              CustomColours.darkPurple,
              () => showDialog<Widget>(
                context: context,
                builder: (BuildContext context) {
                  return const AddVictoryBox();
                },
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
