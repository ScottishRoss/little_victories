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

  Future<bool> showNotificationsConsentIfNeeded() async {
    final bool _isNotificationsEnabled =
        await _notifications.isNotificationAllowed();
    log('Notifications Consent: $_isNotificationsEnabled');
    if (!_isNotificationsEnabled)
      log('Notifications consent not given, showing dialog...');
    _notifications.requestPermissionToSendNotifications();
    return _isNotificationsEnabled;
  }

  Future<bool> showNotificationsConsent() {
    return _notifications.requestPermissionToSendNotifications();
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

  Future<bool> startReminders(String startTime) async {
    final int hour = int.parse(startTime.split(':')[0]);
    final int minute = int.parse(startTime.split(':')[1]);
    try {
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
          hour: hour,
          minute: minute,
          second: 0,
          allowWhileIdle: true,
          repeats: true,
          timeZone: AwesomeNotifications.localTimeZoneIdentifier,
        ),
      );
      return true;
    } catch (e) {
      log('startReminders error: $e');
      return false;
    }
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
}
