import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/res/secure_storage.dart';
import 'package:little_victories/util/firebase_analytics.dart';
import 'package:little_victories/widgets/custom_toast.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
SecureStorage _secureStorage = SecureStorage();
CollectionReference<Map<String, dynamic>> _usersCollection =
    firestore.collection('users');
FToast fToast = FToast();

/// START: Check if user exists.

Future<bool> doesUserExist(User user) async {
  final QuerySnapshot<Object?> snapshot = await firestore
      .collection('users')
      .where('UserId', isEqualTo: user.uid)
      .get();

  if (snapshot.docs.isNotEmpty) {
    return false;
  }

  return true;
}

/// END: Check if user exists.

/// START: Delete User

Future<bool> deleteUser(User user) async {
  final bool topicsDeleted = await deleteTopics(user);
  final bool victoriesDeleted = await deleteAllVictories(user);

  if (topicsDeleted && victoriesDeleted) {
    try {
      await _usersCollection.doc(user.uid).delete();

      fToast.showToast(
        child: const CustomToast(message: 'Victory deleted.'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    } catch (e) {
      fToast.showToast(
        child: const CustomToast(
            message:
                'Something went wrong deleting your account. Try again later.'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    }
  }
  _secureStorage.deleteAll();
  return true;
}

///

/// START: Create User.

Future<bool> createUser(User user) async {
  final DateTime currentDateTime = DateTime.now();
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
    FirebaseAnalyticsService().logEvent('g_sign_up', <String, Object>{
      'method': 'google',
    });
    return true;
  });
  return false;
}

/// END: Create User

/// START: Add Little Victory
Future<bool> saveLittleVictory(
  User user,
  String victory,
  String icon,
) async {
  final DateTime currentDateTime = DateTime.now();

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
    return true;
  });
  return false;
}

/// START: Delete Little Victory

Future<bool> deleteLittleVictory(User user, String docId) async {
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

    return true;
  });
  return false;
}

Future<bool> deleteTopics(User user) async {
  final DocumentReference<Map<String, dynamic>> _topicsDoc =
      _usersCollection.doc(user.uid).collection('notifications').doc('topics');

  try {
    await _topicsDoc.delete();
  } catch (e) {
    fToast.showToast(
      child: const CustomToast(message: 'Something went wrong.'),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
  return true;
}

Future<bool> deleteAllVictories(User user) async {
  final CollectionReference<Map<String, dynamic>> _victoriesCollection =
      _usersCollection.doc(user.uid).collection('victories');

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
  } catch (e) {
    fToast.showToast(
      child: const CustomToast(message: 'Something went wrong.'),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
  return true;
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
