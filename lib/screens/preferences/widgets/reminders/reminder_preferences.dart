import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/data/firestore_operations/firestore_account.dart';
import 'package:little_victories/data/firestore_operations/firestore_notifications.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/util/notifications_service.dart';
import 'package:little_victories/widgets/common/loading.dart';

class ReminderPreferences extends StatefulWidget {
  const ReminderPreferences({Key? key}) : super(key: key);

  @override
  State<ReminderPreferences> createState() => _ReminderPreferencesState();
}

class _ReminderPreferencesState extends State<ReminderPreferences> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _dataList;
  final NotificationsService _notificationsService = NotificationsService();

  final TimeOfDay _sunrise = const TimeOfDay(hour: 7, minute: 0);
  final TimeOfDay _sunset = const TimeOfDay(hour: 18, minute: 0);

  Time selectedTimeOfDay = Time(hour: 18, minute: 30);

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

    updateNotificationTime(formattedTime);

    try {
      _notificationsService.cancelScheduledNotifications();

      _notificationsService.startReminders(formattedTime);
    } catch (e) {
      log('Updating notification time error: $e');
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _dataList = getUserStream();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      height: 140,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _dataList,
            builder: (
              BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
            ) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Loading();
                case ConnectionState.done:
                  return _buildNotificationsList(snapshot);
                case ConnectionState.none:
                  return const Loading();
                case ConnectionState.active:
                  return _buildNotificationsList(snapshot);

                default:
                  if (snapshot.hasError) {
                    return const Center(
                      child:
                          Text('Something went wrong, please try again later.'),
                    );
                  } else {
                    return _buildNotificationsList(snapshot);
                  }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(dynamic snapshot) {
    return FadeIn(
      duration: const Duration(seconds: 1),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Enabled?',
                style: kPreferencesItemStyle,
              ),
              Switch(
                activeColor: CustomColours.hotPink,
                value: snapshot.data!['notificationsEnabled'],
                onChanged: (bool value) async {
                  await toggleNotifications(value);
                },
              ),
            ],
          ),
          if (snapshot.data!['notificationsEnabled'])
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Reminder time',
                  style: kPreferencesItemStyle,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      showPicker(
                        context: context,
                        is24HrFormat: true,
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
                    snapshot.data!['notificationTime'],
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
            )
          else
            const SizedBox()
        ],
      ),
    );
  }
}
