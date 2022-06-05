class Preferences {
  Preferences({
    required this.isNotificationsEnabled,
    required this.notificationTime,
  });

  late final bool isNotificationsEnabled;
  late final String notificationTime;

  set setIsNotificationsEnabled(bool value) {
    isNotificationsEnabled = value;
  }

  set setNotificationTime(String value) {
    notificationTime = value;
  }

  String get getNotificationTime => notificationTime;
  bool get getIsNotifcationsEnabled => isNotificationsEnabled;
}
