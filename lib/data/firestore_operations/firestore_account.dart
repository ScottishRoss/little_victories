import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/data/firestore_operations/firestore_victories.dart';
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
    _usersCollection.doc(user.uid).set(<String, dynamic>{
      'UserId': user.uid,
      'Email': user.email,
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
      isSuccessful = true;
    });

    _usersCollection
        .doc(user.uid)
        .collection('utils')
        .doc('ads')
        .set(<String, dynamic>{
      'counter': '0',
    }).then((_) {
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
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          final GoogleAuthProvider authProvider = GoogleAuthProvider();
          await FirebaseAuth.instance.currentUser!
              .reauthenticateWithProvider(authProvider);
          await FirebaseAuth.instance.currentUser!.delete();
        } else {
          log('Firebase exception $e');
        }
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
  final User? user = FirebaseAuth.instance.currentUser;
  bool isSuccessful = false;
  try {
    log('updateDisplayName attempt: $displayName');
    await user!.updateDisplayName(displayName);
    final User? updatedUser = FirebaseAuth.instance.currentUser;

    if (updatedUser!.displayName == user.displayName) {
      isSuccessful = false;
      log('updateDisplayName: name is the same as before');
    } else {
      isSuccessful = true;
      log('updateDisplayName success: ${updatedUser.displayName}');
      fToast.showToast(
        child: const CustomToast(
          message: 'Display name updated',
        ),
      );
    }
  } catch (e) {
    log('updateDisplayName error: $e');
    fToast.showToast(
      child: const CustomToast(
        message: 'Something weng wrong. Try again later.',
      ),
    );
  }
  return isSuccessful;
}

/// END: Update display name

/// START: Initialise ad counter
Future<bool> initAdCounter() async {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isSuccessful = false;
  try {
    _usersCollection
        .doc(user!.uid)
        .collection('utils')
        .doc('ads')
        .set(<String, int>{
      'counter': 0,
    }).then((_) async {
      isSuccessful = true;
      log('initAdCounter: $isSuccessful');
      return isSuccessful;
    });
  } catch (e) {
    log('initAdCounter error: $e');
  }
  return isSuccessful;
}

/// END: Initialise ad counter

/// START: Update ad counter
Future<bool> updateAdCounter() async {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isSuccessful = false;
  int currentAdCount;
  try {
    currentAdCount = await getAdCounter();

    if (currentAdCount == 3) {
      updateAdCounter();
      currentAdCount = 0;
    } else {
      currentAdCount++;
    }

    _usersCollection
        .doc(user!.uid)
        .collection('utils')
        .doc('ads')
        .set(<String, int>{
      'counter': currentAdCount,
    }).then((_) async {
      isSuccessful = true;
      log('updateAdCounter: $isSuccessful');
      return isSuccessful;
    });
  } catch (e) {
    log('updateAdCounter error: $e');
  }
  return isSuccessful;
}

/// END: updateAdCounter
///
/// Start: getAdCounter

Future<int> getAdCounter() async {
  final User? user = FirebaseAuth.instance.currentUser;
  int? counter;
  try {
    log('getAdCounter starting...');

    final DocumentSnapshot<Map<String, dynamic>> result = await _usersCollection
        .doc(user!.uid)
        .collection('utils')
        .doc('ads')
        .get();

    final Map<String, dynamic>? map = result.data();
    final dynamic counter = map?['counter'];

    log('getAdCounter complete: $counter');
    return counter;
  } catch (e) {
    log('getAdCounter error: $e');
    counter = 0;
  }
  return counter;
}
