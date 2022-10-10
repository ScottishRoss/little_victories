class Preferences {
  Preferences({
    required this.isNotificationsEnabled,
    this.notificationTime,
  });

  late final bool isNotificationsEnabled;
  late final String? notificationTime;

  set setIsNotificationsEnabled(bool value) {
    isNotificationsEnabled = value;
  }

  set setNotificationTime(String value) {
    notificationTime = value;
  }
}
