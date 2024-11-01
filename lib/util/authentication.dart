import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:little_victories/data/firestore_operations/firestore_account.dart';
import 'package:little_victories/data/lv_user_class.dart';
import 'package:little_victories/widgets/common/custom_toast.dart';

class Authentication {
  /// Initialise Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<FirebaseApp> initializeFirebase(
      {required BuildContext context}) async {
    final FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  Future<LVUser?> signInWithGoogle({required BuildContext context}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FToast fToast = FToast();

    fToast.init(context);
    LVUser? lvUser;

    final bool _isUserSignedIn = isUserSignedIn();

    log('Attempting to sign in with Google...');
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: <String>['profile', 'email']);

    if (_isUserSignedIn) {
      await googleSignIn.signOut();
      log('User as already signed in, signed out');
    }

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    log(googleSignInAccount!.email);

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

      lvUser = await createUserIfNeeded(user: userCredential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        log('Error: account-exists-with-different-credential');
        fToast.showToast(
          child: const CustomToast(
            message: 'Sign in failed, please try again later.',
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      } else if (e.code == 'invalid-credential') {
        log('Error: invalid-credential');
        fToast.showToast(
          child: const CustomToast(
            message: 'Sign in failed, please try again later.',
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      } else {
        fToast.showToast(
          child: const CustomToast(
            message: 'Something went wrong.',
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      log('Sign in failed: $e');
      fToast.showToast(
        child: const CustomToast(
          message: 'Sign in failed, please try again later.',
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    }

    return lvUser;
  }

  /// SIGN OUT
  static Future<void> signOutOfGoogle({required BuildContext context}) async {
    log('Signing out of Google...');
    try {
      log('Signing out of Firebase...');
      await FirebaseAuth.instance.signOut().then((dynamic value) =>
          Navigator.pushNamedAndRemoveUntil(
              context, '/sign_in', (Route<dynamic> route) => false));
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, '/sign_in');
      });
    }
  }

  bool isUserSignedIn() {
    final User? _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      log('isUserSignedIn: true');
      return true;
    } else {
      log('isUserSignedIn: false');
      return false;
    }
  }
}
