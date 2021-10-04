import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:little_victories/util/token_monitor.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference _victoriesCollection = firestore.collection('victories');
CollectionReference _usersCollection = firestore.collection('users');

/// START: Check if user exists.

Future<bool> isNewUser(User user) async {

  final QuerySnapshot snapshot = await firestore
      .collection("users")
      .where("UserId", isEqualTo: user.uid)
      .get();

  if (snapshot.docs.isNotEmpty) {
    return false;
  }

  return true;
}

/// END: Check if user exists.

/// START: Create User.

Future<bool> createUser(User user) async {

  final currentDateTime = DateTime.now();
  final token = await FirebaseMessaging.instance.getToken();


  _usersCollection.doc(user.uid).set({
    'UserId' : user.uid,
    'Email': user.email,
    'FCM-Token' : token,
    'CreatedOn' : currentDateTime
  });

  _usersCollection.doc(user.uid).collection("topics").doc(token).set({
    'encouragement' : true,
    'news' : true,
    'reminder' : true
  }).then((_){
    return true;
  });
  return false;
}

/// END: Create User

/// START: Add Little Victory
Future<bool> saveLittleVictory(User user, String victory) async {

  final currentDateTime = DateTime.now();

  _victoriesCollection.add({
    'UserId' : user.uid,
    'Victory' : victory,
    'IV' : 'null',
    'CreatedOn' : currentDateTime
  }).then((_) {
    return true;
  });
  return false;
}

/// START: Delete Little Victory

Future<bool> deleteLittleVictory(String docId) async {

  _victoriesCollection.doc(docId).delete().then((_) {
    return true;
  });
  return false;
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

