import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/common/custom_button.dart';
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
            CustomButton(
              'Preferences',
              () => Navigator.pushNamed(
                context,
                '/preferences',
              ),
            ),

            // View Victories
            CustomButton(
              'View your Victories',
              () => Navigator.pushNamed(
                context,
                '/view_victories',
              ),
            ),
            CustomButton(
              'Debug Screen',
              () => Navigator.pushNamed(
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
