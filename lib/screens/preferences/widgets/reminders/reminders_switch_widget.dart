import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/data/notifications_class.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/util/notifications_service.dart';

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
  final NotificationsService _notificationsService = NotificationsService();

  late bool _isNotificationsEnabled;

  @override
  void initState() {
    super.initState();
    _isNotificationsEnabled = widget.notificationsData.isNotificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final Notifications notificationsData = widget.notificationsData;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('Reminders?'),
        Switch(
          activeColor: CustomColours.hotPink,
          value: _isNotificationsEnabled,
          onChanged: (bool value) async {
            setState(() {
              _isNotificationsEnabled = value;
            });

            // Show notifications consent dialog if user has not yet consented.
            if (_isNotificationsEnabled) {
              _isNotificationsEnabled =
                  await _notificationsService.showNotificationsConsent();
              // _isNotificationsEnabled = await _notificationsService
              //     .showNotificationsConsentIfNeeded();
            }

            // Insert user consent choice
            _notificationsService.setNotificationPreference(
              _isNotificationsEnabled,
            );

            // Update the notifications class
            notificationsData.isNotificationsEnabled = _isNotificationsEnabled;

            // Update the notifications class in Firestore
            updateNotificationPreferences(notificationsData);

            // If notifications are enabled, cancel any scheduled notifications
            // and start the reminders.
            if (_isNotificationsEnabled) {
              _notificationsService.cancelScheduledNotifications();
              _notificationsService.startReminders();
            } else {
              // If notifications are disabled, cancel any scheduled notifications
              _notificationsService.cancelScheduledNotifications();
            }
          },
        ),
      ],
    );
  }
}
