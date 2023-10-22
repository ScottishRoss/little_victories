import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/firestore_operations.dart';
import 'utils.dart';

class Authentication {
  /// Initialise Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase(
      {required BuildContext context}) async {
    final FirebaseApp firebaseApp = await Firebase.initializeApp();

    // final User? user = FirebaseAuth.instance.currentUser;

    // if (user != null) {
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, '/homeFromSignIn', (Route<dynamic> route) => false,
    //       arguments: <User>[user]);
    // }

    return firebaseApp;
  }

  Future<User> signInWithGoogle({required BuildContext context}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    log('kIsWeb: $kIsWeb');

    if (kIsWeb) {
      log('Attempting to sign in with Google...');
      final GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        log('userCredential: $userCredential');

        user = userCredential.user;
        log('user: $user');
      } catch (e) {
        log('Error signing in with Google: $e');
        Navigator.pop(context);
      }
    } else {
      log('Attempting to sign in with Google...');
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      log('googleSignInAccount: $googleSignInAccount');

      if (googleSignInAccount != null) {
        log('googleSignInAccount is not null');
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        log('googleSignInAuthentication: $googleSignInAuthentication');

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        log('credential: $credential');

        try {
          log('Attempting to sign in with Google...');
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          log('userCredential: $userCredential');

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            log('Error: account-exists-with-different-credential');
            buildScaffoldMessenger(context);
          } else if (e.code == 'invalid-credential') {
            log('Error: invalid-credential');
            buildScaffoldMessenger(context,
                content:
                    'Error occurred while accessing credentials. Try again.');
          }
        } catch (e) {
          log('Error occurred using Google Sign In: $e');
          buildScaffoldMessenger(context,
              content: 'Error occurred using Google Sign In. Try again.');
        }
      }
    }

    final bool _isNewUser = await doesUserExist(user!);

    // ignore: always_put_control_body_on_new_line
    if (_isNewUser) createUser(user);

    return user;
  }

  /// SIGN OUT
  static Future<void> signOutOfGoogle({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      buildScaffoldMessenger(context, content: 'Error signing out. Try again.');
    }

    Future<dynamic>.delayed(const Duration(milliseconds: 1000));

    Navigator.pushNamed(context, '/sign_in');
  }

  void authCheck(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      // ignore: unnecessary_statements
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, '/sign_in');
      });
    }
  }
}
