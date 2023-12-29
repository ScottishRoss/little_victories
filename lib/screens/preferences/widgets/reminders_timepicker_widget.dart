import 'package:awesome_notifications/awesome_notifications.dart';
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
  late bool isReminderTimeUpdated = false;
  final SecureStorage _secureStorage = SecureStorage();
  final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();
  final NotificationsService _notificationsService = NotificationsService();

  String formatTimeOfDay(TimeOfDay tod) {
    final DateTime now = DateTime.now();
    final DateTime dt =
        DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final DateFormat format = DateFormat.jm();
    return format.format(dt);
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
    final TimeOfDay convertedTime = TimeOfDay(
        hour: int.parse(time.split(':')[0]),
        minute: int.parse(time.split(':')[1]));
    //final DateFormat format = DateFormat.jm();
    setState(() {
      selectedTime = convertedTime.format(context);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                selectedTime,
                style: kSubtitleStyle.copyWith(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => displayTimeDialog(),
              child: const Text(
                'Change time',
                style: TextStyle(
                  fontSize: 12,
                  color: CustomColours.darkBlue,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColours.teal,
              ),
            ),
          ],
        )
      ],
    );
  }
}
