import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/data/firestore_operations/firestore_account.dart';
import 'package:little_victories/data/lv_user_class.dart';
import 'package:little_victories/data/notifications_class.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference<Map<String, dynamic>> _usersCollection =
    firestore.collection('users');
FToast fToast = FToast();

// START: Get Notifications Data
Future<Notifications> getNotificationsData() async {
  final User user = FirebaseAuth.instance.currentUser!;
  Notifications notifications = Notifications(
    isNotificationsEnabled: false,
    notificationTime: null,
  );
  try {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _usersCollection.doc(user.uid).get();

    if (snapshot.exists) {
      notifications = Notifications.fromMap(snapshot.data()!);
    }
  } catch (e) {
    log('getNotificationsData: $e');
  }
  return notifications;
}

/// END: Set notifications for existing users

/// START: Get Notifications Stream
Stream<DocumentSnapshot<Map<String, dynamic>>> getNotificationsStream() {
  final User user = FirebaseAuth.instance.currentUser!;

  return _usersCollection
      .doc(user.uid)
      .collection('notifications')
      .doc('time')
      .snapshots();
}

/// END: Get Notifications Stream

/// START: Add Little Victory from Notification
Future<bool> saveLittleVictoryFromNotification(
  User user,
  String victory,
) async {
  final DateTime currentDateTime = DateTime.now();
  bool isSuccessful = false;
  try {
    _usersCollection
        .doc(user.uid)
        .collection('victories')
        .doc(currentDateTime.toString())
        .set(<String, dynamic>{
      'victory': victory,
      'createdOn': currentDateTime,
      'icon': 'notification',
    }).then((_) {
      isSuccessful = true;
    });
  } catch (e) {
    log('saveLittleVictoryFromNotification: $e');
  }
  return isSuccessful;
}

/// END: Add Little Victory from Notification

// START: Update Notifications
Future<bool> updateNotificationTime(
  String? notificationTime,
) async {
  bool isSuccessful = false;

  final LVUser? lvUser = await getLVUser();
  if (lvUser != null) {
    try {
      await _usersCollection.doc(lvUser.userId).update(
          <String, dynamic>{'notificationTime': notificationTime}).then((_) {
        isSuccessful = true;
      });
    } catch (e) {
      log('updateNotificationPreferences: $e');
    }
  }
  return isSuccessful;
}

// END: Update Notification Time

// START: Update Notifications
Future<bool> toggleNotifications(
  bool isEnabled,
) async {
  bool isSuccessful = false;

  final LVUser? lvUser = await getLVUser();
  if (lvUser != null) {
    try {
      await _usersCollection.doc(lvUser.userId).update(<String, bool>{
        'notificationsEnabled': isEnabled,
      }).then((_) {
        isSuccessful = true;
      });
    } catch (e) {
      log('notificationsEnabled: $e');
    }
  }
  return isSuccessful;
}

// END: Update Notification Time
