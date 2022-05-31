class Preferences {
  Preferences({
    required this.isNotificationsEnabled,
  });

  late final bool isNotificationsEnabled;

  set setIsNotificationsEnabled(bool value) {
    isNotificationsEnabled = value;
  }

  bool get getIsNotifcationsEnabled => isNotificationsEnabled;
}
