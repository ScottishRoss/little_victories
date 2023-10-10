import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/util/secure_storage.dart';
import 'package:little_victories/widgets/common/custom_button.dart';
import 'package:little_victories/widgets/common/lv_logo.dart';
import 'package:little_victories/widgets/common/page_body.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  _DebugScreenState createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  final SecureStorage _secureStorage = SecureStorage();
  @override
  void initState() {
    Authentication().authCheck(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Little Victories Logo
            const LVLogo(),

            CustomButton(
              'Intro screen',
              () => Navigator.pushReplacementNamed(context, '/intro'),
            ),
            CustomButton(
              'Fire Notification',
              () => NotificationsService().fireNotification(),
            ),
            CustomButton(
              'Cleardown',
              () {
                _secureStorage.deleteAll();
                Authentication.signOutOfGoogle(context: context);
              },
            ),
            CustomButton(
              'List Notifications',
              () async {
                final List<dynamic> notifications =
                    await AwesomeNotifications().listScheduledNotifications();
                print(notifications);
              },
            ),

            CustomButton(
              'Back',
              () => Navigator.pushNamed(
                context,
                '/home',
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
