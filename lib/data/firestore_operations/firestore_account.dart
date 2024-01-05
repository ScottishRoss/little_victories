import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/data/firestore_operations/firestore_victories.dart';
import 'package:little_victories/util/firebase_analytics.dart';
import 'package:little_victories/util/secure_storage.dart';
import 'package:little_victories/widgets/common/custom_toast.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
SecureStorage _secureStorage = SecureStorage();
CollectionReference<Map<String, dynamic>> _usersCollection =
    firestore.collection('users');
FToast fToast = FToast();

/// START: Create User.

Future<bool> createUser({
  required User user,
  String? displayName,
}) async {
  final DateTime currentDateTime = DateTime.now();
  bool isSuccessful = false;

  log('createUser: $user starting create request');

  try {
    final String? token = await FirebaseMessaging.instance.getToken();
    log('createUser: token: $token');

    _usersCollection.doc(user.uid).set(<String, dynamic>{
      'UserId': user.uid,
      'Email': user.email,
      'FCM-Token': token,
      'CreatedOn': currentDateTime
    });

    log('createUser: user documentcreated');

    user.updateDisplayName(displayName);

    log('createUser: user display name updated');

    _usersCollection
        .doc(user.uid)
        .collection('notifications')
        .doc('time')
        .set(<String, dynamic>{
      'isNotificationsEnabled': false,
      'time': '18:30',
    }).then((_) {
      FirebaseAnalyticsService().logEvent('sign_up', <String, Object>{
        'method': 'email',
      });
      isSuccessful = true;
    });

    log('createUser: notifications document created');
  } catch (e) {
    log('createUser error: $e');
    isSuccessful = false;
  }
  return isSuccessful;
}

// END: Create User

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

/// END: Delete User