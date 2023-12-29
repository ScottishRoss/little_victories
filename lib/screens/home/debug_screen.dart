import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../../util/authentication.dart';
import '../../util/notifications_service.dart';
import '../../util/secure_storage.dart';
import '../../widgets/common/custom_button.dart';

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
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
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
    );
  }
}
