import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:little_victories/data/firestore_operations/firestore_account.dart';
import 'package:little_victories/widgets/common/custom_toast.dart';

class Authentication {
  /// Initialise Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<FirebaseApp> initializeFirebase(
      {required BuildContext context}) async {
    final FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FToast fToast = FToast();
    User? user;

    log('kIsWeb: $kIsWeb');

    fToast.init(context);

    // If the platform is web, use the web sign in method
    if (kIsWeb) {
      log('Web sign in: getting authProvider...');
      final GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        log('Web sign in: attempting to get userCredential...');
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        log('Web sign in: user: ${userCredential.user}');

        if (userCredential.user != null)
          Navigator.pushReplacementNamed(
            context,
            '/home',
          );
      } catch (e) {
        log('Error signing in with Google: $e');
        fToast.showToast(
          child: const CustomToast(
            message: 'Sign-in failed, please try again.',
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
        Navigator.pop(context);
      }
    } else {
      log('Attempting to sign in with Google...');
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      log('googleSignInAccount: $googleSignInAccount');

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          log('Attempting to sign in with Google using AuthCredential...');
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;

          log(user.toString());

          Navigator.pushReplacementNamed(context, '/home');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            log('Error: account-exists-with-different-credential');
            fToast.showToast(
              child: const CustomToast(
                message: 'Authentication failed, please try again later.',
              ),
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 2),
            );
          } else if (e.code == 'invalid-credential') {
            log('Error: invalid-credential');
            fToast.showToast(
              child: const CustomToast(
                message: 'Authentication failed, please try again later.',
              ),
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 2),
            );
          }
        } catch (e) {
          log('Error occurred using Google Sign In: $e');
          fToast.showToast(
            child: const CustomToast(
              message: 'Authentication failed, please try again later.',
            ),
            gravity: ToastGravity.BOTTOM,
            toastDuration: const Duration(seconds: 2),
          );
        }
      }
      return null;
    }

    final bool _isNewUser = await doesUserExist(user!);

    // ignore: always_put_control_body_on_new_line
    if (_isNewUser) createUser(user: user);

    return user;
  }

  /// SIGN OUT
  static Future<void> signOutOfGoogle({required BuildContext context}) async {
    log('Signing out of Google...');
    try {
      log('Signing out of Firebase...');
      await FirebaseAuth.instance
          .signOut()
          .then((dynamic value) => log('Signed out!'));

      Navigator.pushNamedAndRemoveUntil(
          context, '/sign_in', (Route<dynamic> route) => false);
    } catch (e) {
      fToast.showToast(
        child: const CustomToast(
          message: 'Something went wrong, please try again later.',
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    }
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
