import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/notifications_class.dart';

import 'constants.dart';
import 'custom_colours.dart';
import 'secure_storage.dart';

const String kNotificationChannelKeyReminders =
    'little_victories_channel_reminders';
const String kNotificationChannelNameReminders = 'Little Victories Reminders';
const String kNotificationChannelRemindersDescription =
    'Little Victories notifications channel for reminders';
const String kNotificationChannelId = 'little_victories_channel_id';
const String kNotificationsChannelGroupKey = 'little_victories_channel_group';
const String kNotificationsChannelGroupName = 'Little Victories Channel Group';

class NotificationsService {
  final AwesomeNotifications _notifications = AwesomeNotifications();
  final SecureStorage _secureStorage = SecureStorage();

  final NotificationContent _notificationContentReminders = NotificationContent(
    id: 1,
    channelKey: kNotificationChannelKeyReminders,
    title: 'Celebrate your Little Victories!',
    body: 'Celebrating your Victories daily will help your wellbeing.',
    wakeUpScreen: true,
    category: NotificationCategory.Reminder,
  );

  final NotificationChannel _notificationChannelReminders = NotificationChannel(
    channelGroupKey: kNotificationsChannelGroupKey,
    channelKey: kNotificationChannelKeyReminders,
    channelName: kNotificationChannelNameReminders,
    channelDescription: kNotificationChannelRemindersDescription,
    ledColor: CustomColours.teal,
    defaultColor: CustomColours.teal,
    importance: NotificationImportance.High,
    enableLights: true,
    enableVibration: true,
  );

  Future<void> init() async {
    _notifications.initialize(
      'resource://drawable/app_icon',
      <NotificationChannel>[
        _notificationChannelReminders,
      ],
      channelGroups: <NotificationChannelGroup>[
        NotificationChannelGroup(
          channelGroupKey: kNotificationsChannelGroupKey,
          channelGroupName: kNotificationsChannelGroupName,
        )
      ],
      debug: isDebugMode(),
    );
  }

  Future<TimeOfDay> convertStringToTimeOfDay(String string) async {
    final DateTime dateTime = DateTime.parse(string);
    final TimeOfDay convertedTime = TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );

    return convertedTime;
  }

  Future<void> showNotificationsConsentIfNeeded() async {
    final bool _isNotificationsEnabled =
        await _notifications.isNotificationAllowed();
    print('Notifications Consent: $_isNotificationsEnabled');
    if (!_isNotificationsEnabled)
      _notifications.requestPermissionToSendNotifications();
  }

  Future<void> cancelScheduledNotifications() async {
    await _notifications.cancelAllSchedules();
  }

  void setNotificationPreference(bool isNotificationsEnabled) {
    final String _notificationsValue =
        isNotificationsEnabled ? 'true' : 'false';
    _secureStorage.insert(
      kIsNotificationsEnabled,
      _notificationsValue,
    );
  }

  Notifications setNotification(
    bool isNotificationActive,
    String notificationTime,
  ) {
    return Notifications.fromMap(<String, dynamic>{
      'isNotificationActive': isNotificationActive,
      'notificationTime': notificationTime,
    });
  }

  Future<void> startReminders() async {
    final String storedTime =
        await _secureStorage.getFromKey(kNotificationTime) ??
            kDefaultNotificationTime;
    log('Stored Time: $storedTime');

    final TimeOfDay tod = await convertStringToTimeOfDay(storedTime);

    log('Time of day: $tod');

    _notifications.createNotification(
      content: _notificationContentReminders,
      actionButtons: <NotificationActionButton>[
        NotificationActionButton(
          key: 'create_victory',
          label: 'Celebrate',
          autoDismissible: true,
          requireInputText: true,
        ),
      ],
      schedule: NotificationCalendar(
        hour: tod.hour,
        minute: tod.minute,
        second: 0,
        allowWhileIdle: true,
        repeats: true,
        timeZone: AwesomeNotifications.localTimeZoneIdentifier,
      ),
    );
    print('Notification started');
  }

  void fireNotification() {
    _notifications.createNotification(
      content: _notificationContentReminders,
      actionButtons: <NotificationActionButton>[
        NotificationActionButton(
          key: 'debug_victory',
          label: 'Celebrate a Victory',
          autoDismissible: true,
          requireInputText: true,
        )
      ],
    );
  }

  TimeOfDay fromDatetimeToTimeOfDay(DateTime dateTime) {
    return TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );
  }

  Future<void> firstTimeNotificationSetup() async {
    bool _isTimeInserted = false;
    log('Starting first time notification setup...');

    //? Check to see if reminders are off or haven't been started.
    final String? _reminderFlag =
        await _secureStorage.getFromKey(kIsNotificationsEnabled);
    log('Reminder flag: $_reminderFlag');

    //? Notifications package check to see if notifications are enabled.
    //? Not final as we do another check later.
    final bool _isNotificationsEnabled =
        await _notifications.isNotificationAllowed();
    log('Notifications enabled: $_isNotificationsEnabled');

    //? If false or null
    if (_reminderFlag == 'false' || _reminderFlag == null) {
      //? Insert the reminder flag.
      _secureStorage.insert(
        kIsNotificationsEnabled,
        _isNotificationsEnabled.toString(),
      );
      log('Set reminder flag to: $_isNotificationsEnabled');

      //? Get the notification time which should be there from initialisation.
      final String? _notificationTime =
          await _secureStorage.getFromKey(kNotificationTime);
      log('Notification time: $_notificationTime');

      //? If null it means it hasn't been initialised so insert the default time.
      if (_notificationTime == null)
        _isTimeInserted = await _secureStorage.insert(
          kNotificationTime,
          kDefaultNotificationTime,
        );
      log('Time inserted: $_isTimeInserted');

      if (_isNotificationsEnabled) {
        //? Start default reminders.
        NotificationsService().startReminders();
        log('Started reminders');
      } else {
        log('Notifications not enabled');
      }
    }
    //? Insert user notifications preference.
    _secureStorage.insert(
      kIsNotificationsEnabled,
      _isNotificationsEnabled.toString(),
    );
  }
}
