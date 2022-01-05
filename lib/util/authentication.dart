import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/util/utils.dart';

class Authentication {
  //TODO: Add Twitter and Facebook authentication. Combine authentications if multiple exist.

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

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    final FirebaseApp firebaseApp = await Firebase.initializeApp();

    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (Route<dynamic> route) => false,
          arguments: <User>[user]);
    }

    return firebaseApp;
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      final GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            buildScaffoldMessenger(context);
          } else if (e.code == 'invalid-credential') {
            buildScaffoldMessenger(context,
                content:
                    'Error occurred while accessing credentials. Try again.');
          }
        } catch (e) {
          buildScaffoldMessenger(context,
              content: 'Error occurred using Google Sign In. Try again.');
        }
      }
    }

    if (await isNewUser(user!)) {
      createUser(user);
    }

    return user;
  }

  /// TODO: Clicking off google accounts screen breaks stuff.

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
      Navigator.pushNamed(context, '/sign_in');
    }
  }
}
