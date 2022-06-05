import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/res/secure_storage.dart';
import 'package:little_victories/util/notifications_service.dart';

class ReminderTimepickerWidget extends StatefulWidget {
  const ReminderTimepickerWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ReminderTimepickerWidgetState createState() =>
      _ReminderTimepickerWidgetState();
}

class _ReminderTimepickerWidgetState extends State<ReminderTimepickerWidget> {
  late String selectedTime = 'ERROR';
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
    print(time);
    return _secureStorage.insert(kNotificationTime, time.toString());
  }

  Future<void> getReminderTime() async {
    final String? time = await _secureStorage.getFromKey(kNotificationTime);
    final DateFormat format = DateFormat.jm();
    if (time != null) {
      setState(() {
        selectedTime = format.format(DateTime.parse(time));
      });
    }
    print(selectedTime);
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
      print(reminderStartDate.toString());
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
      children: <Widget>[
        const Text('Reminder Time: '),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                selectedTime,
                style: kSubtitleStyle,
              ),
            ),
            ElevatedButton(
              onPressed: () => displayTimeDialog(),
              child: const Text('Change time'),
              style: ElevatedButton.styleFrom(
                primary: CustomColours.darkPurple,
              ),
            ),
          ],
        )
      ],
    );
  }
}
