import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';

class NotificationsService {
  final AwesomeNotifications _notifications = AwesomeNotifications();

  void init() {
    _notifications.initialize(
      'resource://drawable/app_icon',
      <NotificationChannel>[
        NotificationChannel(
          channelGroupKey: 'little_victories_channel_group',
          channelKey: 'little_victories_channel',
          channelName: 'Little Victories Notifications',
          channelDescription: 'Notification channel for Little Victories',
          defaultColor: CustomColours.lightPurple,
          ledColor: CustomColours.lightPurple,
        )
      ],
      channelGroups: <NotificationChannelGroup>[
        NotificationChannelGroup(
          channelGroupkey: 'little_victories_channel_group',
          channelGroupName: 'Little Victories Channel Group',
        )
      ],
      debug: isDebugMode(),
    );
  }
}
