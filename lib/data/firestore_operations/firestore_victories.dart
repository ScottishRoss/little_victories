import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/util/ad_helper.dart';
import 'package:little_victories/util/firebase_analytics.dart';
import 'package:little_victories/widgets/common/custom_toast.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference<Map<String, dynamic>> _usersCollection =
    firestore.collection('users');
FToast fToast = FToast();

/// START: Get Victories Stream

Stream<QuerySnapshot<Object?>> getVictoriesStream() {
  final User user = FirebaseAuth.instance.currentUser!;
  return _usersCollection
      .doc(user.uid)
      .collection('victories')
      .orderBy('createdOn', descending: true)
      .snapshots();
}

/// END: Get Victories Stream

/// START: Save Little Victory
Future<bool> saveLittleVictory(
  String victory,
  String icon,
) async {
  bool isSuccessful = false;
  final DateTime currentDateTime = DateTime.now();
  log('saveLittleVictory: $currentDateTime');
  final User user = FirebaseAuth.instance.currentUser!;

  try {
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

/// END: Save Little Victory

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

/// END: Delete Little Victory

/// START: Delete all Victories

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

/// END: Delete all Victories

/// START: Victories analytics

Future<AggregateQuerySnapshot> getVictoriesAnalytics() async {
  final User user = FirebaseAuth.instance.currentUser!;
  final AggregateQuerySnapshot result = await _usersCollection
      .doc(user.uid)
      .collection('victories')
      .count()
      .get();
  return result;
}

/// END: Victories analytics
/// 
