import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class LVUser {
  LVUser({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.notificationsEnabled,
    required this.notificationTime,
    required this.adCounter,
  });

  factory LVUser.convertDocumentToLVUser(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
  ) {
    final QueryDocumentSnapshot<Object?>? result = snapshot.data?.docs[0];
    return LVUser.fromDocument(result!);
  }

  factory LVUser.fromDocument(QueryDocumentSnapshot<Object?> doc) {
    final Map<String, dynamic> data = doc as Map<String, dynamic>;

    return LVUser.fromJson(data);
  }

  factory LVUser.fromJson(Map<String, dynamic> json) {
    final String userId = json['UserId'];
    final String email = json['Email'];
    final String displayName = json['displayName'];
    final bool notificationsEnabled = json['notificationsEnabled'];
    final String notificationTime = json['notificationTime'];
    final int adCounter = json['adCounter'];

    return LVUser(
      userId: userId,
      email: email,
      displayName: displayName,
      notificationsEnabled: notificationsEnabled,
      notificationTime: notificationTime,
      adCounter: adCounter,
    );
  }

  String userId, email, notificationTime, displayName;
  bool notificationsEnabled;
  int adCounter;
}
