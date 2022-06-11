import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/res/secure_storage.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/common/custom_button.dart';
import 'package:little_victories/widgets/common/lv_logo.dart';
import 'package:little_victories/widgets/common/page_body.dart';
import 'package:little_victories/widgets/modals/notifications_consent_modal.dart';

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
      child: Column(
        children: <Widget>[
          // Little Victories Logo
          const LVLogo(),
          const Spacer(),
          // Preferences Button
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
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
