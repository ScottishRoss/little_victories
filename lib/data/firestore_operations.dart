import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/data/notifications_class.dart';

import '../util/firebase_analytics.dart';
import '../util/secure_storage.dart';
import '../widgets/common/custom_toast.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
SecureStorage _secureStorage = SecureStorage();
CollectionReference<Map<String, dynamic>> _usersCollection =
    firestore.collection('users');
FToast fToast = FToast();

/// START: Check if user exists.

Future<bool> doesUserExist(User user) async {
  bool userExists = false;
  try {
    final QuerySnapshot<Object?> snapshot = await firestore
        .collection('users')
        .where('UserId', isEqualTo: user.uid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      userExists = true;
    } else {
      userExists = false;
    }
  } catch (e) {
    log('doesUserExist: $e');
  }
  return userExists;
}

/// END: Check if user exists.

/// START: Delete User

Future<bool> deleteUser() async {
  final User user = FirebaseAuth.instance.currentUser!;
  // final bool topicsDeleted = await deleteTopics(user);
  bool userDeleted = false;
  bool victoriesDeleted = false;
  bool isSuccessful = false;
  log('deleteUser: $user starting delete request');

  // Delete all Victories from the users collection.

  log('deleteUser: attempting to delete victories...');
  try {
    await deleteAllVictories(user);
    victoriesDeleted = true;
    log('deleteUser: victories deleted');
  } catch (e) {
    log('deleteUser: error deleting victories - $e');
  }

  // If Victories have been deleted, delete the user.

  if (victoriesDeleted) {
    log('deleteUser: attempting to delete Victories...');
    try {
      await _usersCollection.doc(user.uid).delete();
      log('deleteUser: user deleted');
      userDeleted = true;
    } catch (e) {
      log('deleteUser: error deleting user - $e');
    }

    // If the user has been deleted, delete the user from Secure Storage.

    if (victoriesDeleted && userDeleted) {
      log('deleteUser: attempting to delete user from Secure Storage...');
      try {
        await _secureStorage.deleteFromKey('user');
        log('deleteUser: user deleted from Secure Storage');

        fToast.showToast(
          child: const CustomToast(message: 'Account deleted.'),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      } catch (e) {
        log('deleteUser: error deleting user from Secure Storage - $e');
      }
    }

    // Victories and User have to be deleted to be considered successful.

    if (victoriesDeleted && userDeleted) {
      isSuccessful = true;
      fToast.showToast(
        child: const CustomToast(message: 'Account deleted.'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    } else {
      fToast.showToast(
        child: const CustomToast(
          message:
              'Something went wrong deleting your account. Try again later.',
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    }
  }

  return isSuccessful;
}

///

/// START: Create User.

Future<bool> createUser(User user) async {
  final DateTime currentDateTime = DateTime.now();
  bool isSuccessful = false;

  try {
    final String? token = await FirebaseMessaging.instance.getToken();

    _usersCollection.doc(user.uid).set(<String, dynamic>{
      'UserId': user.uid,
      'Email': user.email,
      'FCM-Token': token,
      'CreatedOn': currentDateTime
    });

    _usersCollection
        .doc(user.uid)
        .collection('notifications')
        .doc('topics')
        .set(<String, dynamic>{
      'encouragement': true,
      'news': true,
      'reminder': true
    }).then((_) {
      FirebaseAnalyticsService().logEvent('sign_up', <String, Object>{
        'method': 'email',
      });
      isSuccessful = true;
    });
  } catch (e) {
    log('Error: $e');
    isSuccessful = false;
  }
  return isSuccessful;
}

/// END: Create User

/// START: Get Victories Stream
Stream<QuerySnapshot<Object?>> getVictoriesStream() {
  final User user = FirebaseAuth.instance.currentUser!;
  return _usersCollection
      .doc(user.uid)
      .collection('victories')
      .orderBy('createdOn', descending: true)
      .snapshots();
}

/// START: Get Notifications Stream
Stream<DocumentSnapshot<Map<String, dynamic>>> getNotificationsStream() {
  final User user = FirebaseAuth.instance.currentUser!;

  return _usersCollection
      .doc(user.uid)
      .collection('notifications')
      .doc('time')
      .snapshots();
}

/// START: Add Little Victory
Future<bool> saveLittleVictory(
  String victory,
  String icon,
) async {
  bool isSuccessful = false;
  log('saveLittleVictory: $victory $icon');
  final DateTime currentDateTime = DateTime.now();
  log('saveLittleVictory: $currentDateTime');
  final User user = FirebaseAuth.instance.currentUser!;
  log('saveLittleVictory: ${user.email}');

  try {
    log('saveLittleVictory: $user');
    _usersCollection
        .doc(user.uid)
        .collection('victories')
        .doc(currentDateTime.toString())
        .set(<String, dynamic>{
      'victory': victory,
      'createdOn': currentDateTime,
      'icon': icon
    }).then((_) {
      FirebaseAnalyticsService().logEvent('submit_victory', <String, Object>{
        'submit': 'true',
      });
      log('saveLittleVictory: Logged event');
    });
    isSuccessful = true;
    log('saveLittleVictory: Success!');
  } catch (e) {
    log('saveLittleVictory: $e');
    fToast.showToast(
      child: const CustomToast(
          message:
              'Something went wrong saving your Victory. Try again later.'),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
  return isSuccessful;
}

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
      FirebaseAnalyticsService()
          .logEvent('submit_victory_from_notification', <String, Object>{
        'submit': 'true',
      });
      isSuccessful = true;
    });
  } catch (e) {
    log('saveLittleVictoryFromNotification: $e');
  }
  return isSuccessful;
}

/// START: Delete Little Victory

Future<bool> deleteLittleVictory(String docId) async {
  final User user = FirebaseAuth.instance.currentUser!;
  bool isSuccessful = false;
  try {
    await _usersCollection
        .doc(user.uid)
        .collection('victories')
        .doc(docId)
        .delete()
        .then((_) {
      fToast.showToast(
        child: const CustomToast(message: 'Victory deleted.'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );

      isSuccessful = true;
    });
  } catch (e) {
    log('deleteLittleVictory: $e');
    fToast.showToast(
      child: const CustomToast(
          message:
              'Something went wrong deleting your Victory. Try again later.'),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
  return isSuccessful;
}

// Future<bool> deleteTopics(User user) async {
//   final DocumentReference<Map<String, dynamic>> _topicsDoc =
//       _usersCollection.doc(user.uid).collection('notifications').doc('topics');

//   try {
//     await _topicsDoc.delete();
//   } catch (e) {
//     fToast.showToast(
//       child: const CustomToast(message: 'Something went wrong.'),
//       gravity: ToastGravity.BOTTOM,
//       toastDuration: const Duration(seconds: 2),
//     );
//   }
//   return true;
// }

Future<bool> deleteAllVictories(User user) async {
  final CollectionReference<Map<String, dynamic>> _victoriesCollection =
      _usersCollection.doc(user.uid).collection('victories');
  bool isSuccessful = false;

  try {
    _victoriesCollection
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> value) {
      for (final QueryDocumentSnapshot<Map<String, dynamic>> result
          in value.docs) {
        final String id = result.id;
        _victoriesCollection.doc(id).delete();
      }
    });
    isSuccessful = true;
  } catch (e) {
    log('deleteAllVictories: $e');
    fToast.showToast(
      child: const CustomToast(message: 'Something went wrong.'),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
  return isSuccessful;
}

// START: Update Notification Time
Future<bool> updateNotificationPreferences(Notifications notifications) async {
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

// START: Get Notifications Data
Future<Notifications> getNotificationsData() async {
  final User user = FirebaseAuth.instance.currentUser!;
  Notifications notifications = Notifications(
    isNotificationsEnabled: false,
    notificationTime: '18:30',
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



/// START: Update Push Notification Preferences
//
// Future<bool> updatePushNotificationPreferences(User user, String topic, bool) async {
//
//   _usersCollection.doc(user.uid).collection("topics").doc(token).set({
//     'encouragement' : true,
//     'news' : true,
//     'reminder' : true
//   }).then((_){
//     return true;
//   });
//   return false;
// }
