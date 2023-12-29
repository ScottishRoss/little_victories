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

  Time? selectedTimeOfDay;
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
    final DateFormat format = DateFormat.jm();
    return format.format(dt);
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      selectedTimeOfDay = Time.fromTimeOfDay(newTime, 0);
      selectedTime = formatTimeOfDay(newTime);
    });
  }

  Future<bool> setReminderTime(String time) async {
    final List<NotificationModel> _notificationsList =
        await _awesomeNotifications.listScheduledNotifications();

    if (_notificationsList.isNotEmpty) {
      _notificationsService.cancelScheduledNotifications();
    }

    return _secureStorage.insert(kNotificationTime, time.toString());
  }

  Future<void> getReminderTime() async {
    final String time = await _secureStorage.getFromKey(kNotificationTime) ??
        kDefaultNotificationTime;
    final TimeOfDay tod =
        await _notificationsService.convertStringToTimeOfDay(time);

    final Time timeOfDay = Time(hour: tod.hour, minute: tod.minute);

    setState(() {
      selectedTimeOfDay = timeOfDay;
    });
  }

  Future<void> displayTimeDialog() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      helpText: 'Select a time',
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? Container(),
        );
      },
    );
    if (time != null) {
      final DateTime now = DateTime.now();
      final DateTime reminderStartDate =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);

      await _secureStorage.deleteFromKey(kNotificationTime);
      await _secureStorage.insert(
          kNotificationTime, reminderStartDate.toString());
      _notificationsService.startReminders();
    }
    Navigator.pushNamed(context, '/preferences');
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
                value: selectedTimeOfDay!,
                barrierColor: CustomColours.darkBlue.withOpacity(0.5),
                sunrise: _sunrise,
                sunset: _sunset,
                duskSpanInMinutes: 120,
                onChange: onTimeChanged,
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
