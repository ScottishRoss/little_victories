import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/data/firestore_operations/firestore_victories.dart';
import 'package:little_victories/data/lv_user_class.dart';
import 'package:little_victories/util/secure_storage.dart';
import 'package:little_victories/widgets/common/custom_toast.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
SecureStorage _secureStorage = SecureStorage();
CollectionReference<Map<String, dynamic>> _usersCollection =
    firestore.collection('users');
FToast fToast = FToast();

/// START: Check if user exists.

Future<LVUser?> doesUserExist(User user) async {
  try {
    final QuerySnapshot<Object?> snapshot = await firestore
        .collection('users')
        .where('UserId', isEqualTo: user.uid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return getLVUser();
    }
  } catch (e) {
    log('doesUserExist: $e');
  }

  return null;
}

/// END: Check if user exists.

/// START: Create User.

Future<LVUser> createUserIfNeeded({
  required User user,
}) async {
  LVUser? lvUser;

  lvUser = await doesUserExist(user);

  if (lvUser == null) {
    lvUser = LVUser(
      userId: user.uid,
      email: user.email!,
      displayName: user.displayName!.split(' ')[0],
      notificationsEnabled: false,
      notificationTime: '18:30',
      adCounter: 0,
    );

    log('createUser: $user starting create request');

    try {
      _usersCollection.doc(user.uid).set(<String, dynamic>{
        'UserId': lvUser.userId,
        'Email': lvUser.email,
        'displayName': lvUser.displayName,
        'notificationsEnabled': lvUser.notificationsEnabled,
        'notificationTime': lvUser.notificationTime,
        'adCounter': lvUser.adCounter,
      });

      log('createUser: user document created');

      user.updateDisplayName(user.displayName);

      log('createUser: user display name updated');
    } catch (e) {
      log('createUser error: $e');
    }
  } else {
    log('User already exists.');
  }
  return lvUser;
}

// END: Create User

/// START: Get User data

Future<LVUser?> getLVUser() async {
  final User user = FirebaseAuth.instance.currentUser!;
  log('userId: ${user.uid}');
  final DocumentSnapshot<Map<String, dynamic>> result =
      await _usersCollection.doc(user.uid).get();
  log(result.data().toString());

  return LVUser.fromJson(result.data()!);
}

/// START: Delete User

Future<bool> deleteUser(BuildContext context) async {
  final User user = FirebaseAuth.instance.currentUser!;
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

  // If Victories have been deleted, sign out and delete the user.

  if (victoriesDeleted) {
    log('deleteUser: attempting to delete user...');
    try {
      await _usersCollection.doc(user.uid).delete();
      log('deleteUser: user document deleted');
      try {
        await FirebaseAuth.instance.currentUser!.delete();
        // } on FirebaseAuthException catch (e) {
        //   if (e.code == 'requires-recent-login') {
        //     final GoogleAuthProvider authProvider = GoogleAuthProvider();
        //     await FirebaseAuth.instance.currentUser!
        //         .reauthenticateWithProvider(authProvider);
        //     await FirebaseAuth.instance.currentUser!.delete();
        //   } else {
        //     log('Firebase exception $e');
        //   }
      } catch (e) {
        log('Exception $e');
      }
      userDeleted = true;
    } catch (e) {
      log('deleteUser: error deleting user - $e');
    }

    // If the user has been deleted, delete the user from Secure Storage.

    if (victoriesDeleted && userDeleted) {
      log('deleteUser: attempting to delete Secure Storage');
      try {
        await _secureStorage.deleteAll();
        log('deleteUser: secure storage deleted');
      } catch (e) {
        log('deleteUser: error deleting secure storage - $e');
      }
    }

    // Victories and User have to be deleted to be considered successful.

    if (victoriesDeleted && userDeleted) {
      isSuccessful = true;

      if (isSuccessful) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/sign_in',
          (Route<dynamic> route) => false,
        );
      }

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

/// START: Update display name
Future<bool> updateDisplayName(
  String displayName,
  BuildContext context,
) async {
  LVUser? lvUser = await getLVUser();
  bool isSuccessful = false;

  if (lvUser != null) {
    try {
      log('updateDisplayName attempt: $displayName');

      if (displayName == lvUser.displayName) {
        isSuccessful = false;
        log('updateDisplayName: name is the same as before');
      } else {
        _usersCollection.doc(lvUser.userId).update(<String, String>{
          'displayName': displayName,
        });
        log('updateDisplayName: Updated, checking...');

        lvUser = await getLVUser();

        if (lvUser!.displayName == displayName) {
          isSuccessful = true;
        }
      }
    } catch (e) {
      log('updateDisplayName error: $e');
      fToast.showToast(
        child: const CustomToast(
          message: 'Something weng wrong. Try again later.',
        ),
      );
    }

    if (isSuccessful) {
      fToast.showToast(
        child: const CustomToast(
          message: 'Updated display name',
        ),
      );
    } else {
      fToast.showToast(
        child: const CustomToast(
          message: 'Something weng wrong. Try again later.',
        ),
      );
    }
  }
  return isSuccessful;
}

/// END: Update display name

/// START: Update ad counter
Future<bool> updateAdCounter() async {
  final LVUser? lvUser = await getLVUser();
  bool isSuccessful = false;
  int currentAdCount;
  if (lvUser != null) {
    try {
      currentAdCount = lvUser.adCounter;

      if (currentAdCount == 3) {
        currentAdCount = 0;
      } else {
        currentAdCount++;
      }

      _usersCollection.doc(lvUser.userId).update(<String, int>{
        'adCounter': currentAdCount,
      }).then((_) async {
        isSuccessful = true;
        log('updateAdCounter: $isSuccessful');
        return isSuccessful;
      });
    } catch (e) {
      log('updateAdCounter error: $e');
    }
  }
  return isSuccessful;
}

/// END: updateAdCounter
///
/// Start: getUserStream

Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream() {
  final User user = FirebaseAuth.instance.currentUser!;

  return _usersCollection.doc(user.uid).snapshots();
}
