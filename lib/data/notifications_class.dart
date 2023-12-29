class Notifications {
  Notifications({
    required this.isNotificationsEnabled,
    this.notificationTime,
  });

  Notifications.fromMap(Map<String, dynamic> map) {
    isNotificationsEnabled = map['isNotificationsEnabled'] as bool;
    notificationTime = map['notificationTime'] as String;
  }

  late final bool isNotificationsEnabled;
  late final String? notificationTime;

  set setIsNotificationsEnabled(bool value) {
    isNotificationsEnabled = value;
  }

  set setNotificationTime(String value) {
    notificationTime = value;
  }
}
