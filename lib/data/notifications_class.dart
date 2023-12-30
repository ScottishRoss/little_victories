import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  Notifications({
    required this.isNotificationsEnabled,
    required this.notificationTime,
  });

  Notifications.fromMap(Map<String, dynamic> map) {
    isNotificationsEnabled = map['isNotificationsEnabled'] as bool;
    notificationTime = map['time'] as String;
  }

  factory Notifications.fromDocument(QueryDocumentSnapshot<dynamic> doc) {
    final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

    return Notifications.fromMap(data);
  }

  factory Notifications.fromJson(Map<String, dynamic> json) {
    final bool isNotificationsEnabled = json['isNotificationsEnabled'] as bool;
    final String notificationsTime = json['time'] as String;

    return Notifications(
      isNotificationsEnabled: isNotificationsEnabled,
      notificationTime: notificationsTime,
    );
  }

  late bool isNotificationsEnabled;
  late final String notificationTime;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'isNotificationsEnabled': isNotificationsEnabled,
      'time': notificationTime,
    };
  }
}
