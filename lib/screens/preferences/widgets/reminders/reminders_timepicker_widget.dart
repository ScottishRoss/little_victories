import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/data/notifications_class.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/util/secure_storage.dart';

class ReminderTimepickerWidget extends StatefulWidget {
  const ReminderTimepickerWidget({
    Key? key,
    required this.notificationsData,
  }) : super(key: key);

  final Notifications notificationsData;

  @override
  _ReminderTimepickerWidgetState createState() =>
      _ReminderTimepickerWidgetState();
}

class _ReminderTimepickerWidgetState extends State<ReminderTimepickerWidget> {
  String selectedTime = kDefaultNotificationTime;

  Time selectedTimeOfDay = Time(hour: 18, minute: 30);
  late bool isReminderTimeUpdated = false;
  final SecureStorage _secureStorage = SecureStorage();
  final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();
  final NotificationsService _notificationsService = NotificationsService();

  final TimeOfDay _sunrise = const TimeOfDay(hour: 6, minute: 0);
  final TimeOfDay _sunset = const TimeOfDay(hour: 18, minute: 0);

  bool isDayTime(TimeOfDay now) {
    final int currentHour = now.hour;
    final int sunriseHour = _sunrise.hour;
    final int sunsetHour = _sunset.hour;

    return currentHour >= sunriseHour && currentHour < sunsetHour;
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final DateTime now = DateTime.now();
    final DateTime dt =
        DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat('HH:mm').format(dt);
  }

  Future<bool> setReminderTime(TimeOfDay newTime) async {
    final String formattedTime = formatTimeOfDay(newTime);
    final Time newParseTime = Time.fromTimeOfDay(
      newTime,
      0,
    );
    log('newParseTime: $newParseTime');
    setState(() {
      selectedTimeOfDay = newParseTime;
      selectedTime = formattedTime;
    });
    try {
      final List<NotificationModel> _notificationsList =
          await _awesomeNotifications.listScheduledNotifications();

      if (_notificationsList.isNotEmpty) {
        _notificationsService.cancelScheduledNotifications();
      }

      _secureStorage.insert(kNotificationTime, formattedTime);
      _notificationsService.startReminders();
    } catch (e) {
      print(e);
    }
    return true;
  }

  Future<void> getReminderTime() async {
    final String string = await _secureStorage.getFromKey(kNotificationTime) ??
        kDefaultNotificationTime;

    log('getReminderTime: $string');

    final int hour = int.parse(string.split(':')[0]);
    final int minute = int.parse(string.split(':')[1]);

    final Time timeOfDay = Time(
      hour: hour,
      minute: minute,
    );

    setState(() {
      selectedTime = string;
      selectedTimeOfDay = timeOfDay;
    });
  }

  @override
  void initState() {
    getReminderTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.notificationsData.isNotificationsEnabled
        ? _buildReminderTimeRow
        : const SizedBox();
  }

  Widget get _buildReminderTimeRow {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('Reminder time'),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              showPicker(
                context: context,
                themeData: isDayTime(TimeOfDay.now())
                    ? kTimePickerLightTheme
                    : kTimePickerDarkTheme,
                value: selectedTimeOfDay,
                barrierColor: CustomColours.darkBlue.withOpacity(0.5),
                sunrise: _sunrise,
                sunset: _sunset,
                duskSpanInMinutes: 120,
                onChange: setReminderTime,
              ),
            );
          },
          child: Text(
            selectedTime,
            style: const TextStyle(
              fontSize: 16,
              color: CustomColours.darkBlue,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColours.teal,
          ),
        ),
      ],
    );
  }
}
