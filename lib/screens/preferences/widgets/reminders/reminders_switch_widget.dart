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
  late Notifications _notificationData;

  @override
  void initState() {
    super.initState();
    _notificationData = widget.notificationsData;
    _isNotificationsEnabled = _notificationData.isNotificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('Enabled?'),
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

            // If notifications are still enabled, continue.
            if (_isNotificationsEnabled) {
              // Insert user consent choice
              _notificationsService.setNotificationPreference(
                _isNotificationsEnabled,
              );

              // Update the notifications class
              _notificationData = Notifications(
                isNotificationsEnabled: _isNotificationsEnabled,
                notificationTime: _notificationData.notificationTime,
              );

              // Update the notifications class in Firestore
              updateNotificationPreferences(_notificationData);

              // If notifications are enabled, cancel any scheduled notifications
              // and start the reminders.

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
