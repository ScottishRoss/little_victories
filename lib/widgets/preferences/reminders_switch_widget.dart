import 'package:flutter/material.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/res/secure_storage.dart';
import 'package:little_victories/util/notifications_service.dart';

class RemindersSwitchWidget extends StatefulWidget {
  const RemindersSwitchWidget({
    Key? key,
    required this.isPreferencesEnabled,
  }) : super(key: key);

  final bool isPreferencesEnabled;

  @override
  _RemindersSwitchWidgetState createState() => _RemindersSwitchWidgetState();
}

class _RemindersSwitchWidgetState extends State<RemindersSwitchWidget> {
  final SecureStorage _secureStorage = SecureStorage();
  final NotificationsService _notificationsService = NotificationsService();

  late bool _isPreferencesEnabled;

  @override
  void initState() {
    super.initState();
    _isPreferencesEnabled = widget.isPreferencesEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Reminders: '),
        Switch(
          activeColor: CustomColours.teal,
          value: _isPreferencesEnabled,
          onChanged: (bool value) async {
            setState(() {
              _isPreferencesEnabled = value;
            });
            _notificationsService.setNotificationPreference(
              _isPreferencesEnabled,
            );
            _secureStorage.insert(
              kIsNotificationsEnabled,
              _isPreferencesEnabled.toString(),
            );

            if (value) {
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
