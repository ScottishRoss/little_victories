import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/secure_storage.dart';
import 'package:little_victories/widgets/modals/notifications_consent_modal.dart';

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
          channelGroupkey: kNotificationsChannelGroupKey,
          channelGroupName: kNotificationsChannelGroupName,
        )
      ],
      debug: isDebugMode(),
    );
  }

  Future<void> showNotificationModal(BuildContext context) async {
    final String? _isFirstTime = await _secureStorage.getFromKey(
      kFirstTimeSetup,
    );
    if (_isFirstTime == null) {
      showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return const NotificationsConsentModal();
        },
      );
      final DateTime now = DateTime.now();
      _secureStorage.insert(kFirstTimeSetup, 'true');
      _secureStorage.insert(
        kNotificationTime,
        DateTime(
          now.year,
          now.month,
          now.day,
          18,
          0,
        ).toString(),
      );
    }
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

  Future<void> startReminders() async {
    final String? storedTime =
        await _secureStorage.getFromKey(kNotificationTime);
    final TimeOfDay convertedTime = fromDatetimeToTimeOfDay(
      DateTime.parse(storedTime!),
    );
    final int hour = convertedTime.hour;
    final int minute = convertedTime.minute;

    _notifications.createNotification(
      content: _notificationContentReminders,
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        allowWhileIdle: true,
        repeats: true,
        timeZone: AwesomeNotifications.localTimeZoneIdentifier,
      ),
    );
    print('Notification created: hour = $hour, minute = $minute');
  }

  void fireNotification() {
    _notifications.createNotification(
      content: _notificationContentReminders,
    );
  }

  TimeOfDay fromDatetimeToTimeOfDay(DateTime dateTime) {
    return TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );
  }
}
