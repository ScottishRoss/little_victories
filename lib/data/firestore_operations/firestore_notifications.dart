import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        await _usersCollection
            .doc(user.uid)
            .collection('notifications')
            .doc('time')
            .get();

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

// START: Update Notification Time
Future<bool> updateNotificationPreferences(
  Notifications notifications,
) async {
  bool isSuccessful = false;
  final User user = FirebaseAuth.instance.currentUser!;
  try {
    await _usersCollection
        .doc(user.uid)
        .collection('notifications')
        .doc('time')
        .set(<String, dynamic>{
      'isNotificationsEnabled': notifications.isNotificationsEnabled,
      'time': notifications.notificationTime,
    }).then((_) {
      isSuccessful = true;
      log('updateNotificationPreferences: ${notifications.isNotificationsEnabled} - ${notifications.notificationTime}');
    });
  } catch (e) {
    log('updateNotificationPreferences: $e');
  }
  return isSuccessful;
}

// END: Update Notification Time

/// START: Set notifications for existing users
Future<bool> setNotificationsForExistingUsers() async {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isSuccessful = false;
  try {
    final Notifications _notifications = await getNotificationsData();

    if (_notifications.notificationTime == null) {
      updateNotificationPreferences(_notifications);

      _usersCollection
          .doc(user!.uid)
          .collection('notifications')
          .doc('time')
          .set(<String, dynamic>{
        'isNotificationsEnabled': true,
        'time': '18:30',
      }).then((_) {
        isSuccessful = true;
      });
    }
  } catch (e) {
    log(e.toString());
  }
  return isSuccessful;
}

/// START: Set notifications for existing users
Future<bool> setNotificationsForNewUsers() async {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isSuccessful = false;
  try {
    final Notifications _notifications = await getNotificationsData();

    if (_notifications.notificationTime == null) {
      updateNotificationPreferences(_notifications);

      _usersCollection
          .doc(user!.uid)
          .collection('notifications')
          .doc('time')
          .set(<String, dynamic>{
        'isNotificationsEnabled': false,
        'time': '18:30',
      }).then((_) {
        isSuccessful = true;
      });
    }
  } catch (e) {
    log(e.toString());
  }
  return isSuccessful;
}
