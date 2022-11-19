import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/secure_storage.dart';

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
    print('Stored Time: $storedTime');

    //? Split the 24 hour time into hours and minutes as a list.
    final List<String> parts = storedTime!.split(':');

    _notifications.createNotification(
      content: _notificationContentReminders,
      actionButtons: <NotificationActionButton>[
        NotificationActionButton(
          key: 'create_victory',
          label: 'Celebrate',
          autoDismissible: true,
          buttonType: ActionButtonType.InputField,
        )
      ],
      schedule: NotificationCalendar(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
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
          buttonType: ActionButtonType.InputField,
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
    //? Check to see if reminders are off or haven't been started.
    final String? _reminderFlag =
        await _secureStorage.getFromKey(kIsNotificationsEnabled);
    //? Notifications package check to see if notifications are enabled.
    //? Not final as we do another check later.
    bool _isNotificationsEnabled = await _notifications.isNotificationAllowed();

    //? If false or null
    if (_reminderFlag == 'false' || _reminderFlag == null) {
      //? Get the notification time which should be there from initialisation.
      final String? _notificationTime =
          await _secureStorage.getFromKey(kNotificationTime);
      //? If null it means it hasn't been initialised so insert the default time.
      if (_notificationTime == null)
        _secureStorage.insert(
          kNotificationTime,
          kDefaultNotificationTime,
        );

      //? If notifications haven't been enabled on startup, take them to the settings.
      if (_isNotificationsEnabled == null) {
        _notifications.requestPermissionToSendNotifications();
        //? Recheck if notifications are enabled.
        _isNotificationsEnabled = await _notifications.isNotificationAllowed();
      }

      //? Start default reminders.
      NotificationsService().startReminders();
    }
    //? Insert user notifications preference.
    _secureStorage.insert(
      kIsNotificationsEnabled,
      _isNotificationsEnabled.toString(),
    );
  }
}
