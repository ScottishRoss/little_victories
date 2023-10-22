import 'package:flutter/material.dart';
import '../../util/constants.dart';
import '../../util/custom_colours.dart';
import '../../util/notifications_service.dart';
import '../../util/secure_storage.dart';

class RemindersSwitchWidget extends StatefulWidget {
  const RemindersSwitchWidget({
    Key? key,
    required this.isNotificationsEnabled,
  }) : super(key: key);

  final bool isNotificationsEnabled;

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
    _isNotificationsEnabled = widget.isNotificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Reminders: '),
        Switch(
          activeColor: CustomColours.teal,
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
        ),
      ],
    );
  }
}
