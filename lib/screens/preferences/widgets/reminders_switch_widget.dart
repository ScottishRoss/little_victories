import 'package:flutter/material.dart';
import 'package:little_victories/data/notifications_class.dart';

import '../../../util/constants.dart';
import '../../../util/custom_colours.dart';
import '../../../util/notifications_service.dart';
import '../../../util/secure_storage.dart';

class RemindersSwitchWidget extends StatefulWidget {
  const RemindersSwitchWidget({
    Key? key,
    required this.notificationsData,
  }) : super(key: key);

  final Notifications notificationsData;

  @override
  _RemindersSwitchWidgetState createState() => _RemindersSwitchWidgetState();
}

class _RemindersSwitchWidgetState extends State<RemindersSwitchWidget> {
  final SecureStorage _secureStorage = SecureStorage();
  final NotificationsService _notificationsService = NotificationsService();

  late bool _isNotificationsEnabled;

  @override
  void initState() {
    super.initState();
    _isNotificationsEnabled = widget.notificationsData.isNotificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: CustomColours.hotPink,
      value: _isNotificationsEnabled,
      onChanged: (bool value) async {
        setState(() {
          _isNotificationsEnabled = value;
        });
        _notificationsService.setNotificationPreference(
          _isNotificationsEnabled,
        );
        _secureStorage.insert(
          kIsNotificationsEnabled,
          _isNotificationsEnabled.toString(),
        );

        if (value) {
          _notificationsService.showNotificationsConsentIfNeeded();
          _notificationsService.cancelScheduledNotifications();
          _notificationsService.startReminders();
        } else {
          _notificationsService.cancelScheduledNotifications();
        }
      },
    );
  }
}
