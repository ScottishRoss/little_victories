import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
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

  static Future<User?> linkingAccounts(
      String platform, AuthCredential authCred, String? emailId) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential? userCred;
    UserCredential? signInCred;
    if (platform == 'google.com') {
      final GoogleSignIn _gSignIn = GoogleSignIn();
      final GoogleSignInAccount? gSignInAccount = await _gSignIn.signIn();
      GoogleSignInAuthentication? googleSignInAuthentication;
      try {
        googleSignInAuthentication = await gSignInAccount!.authentication;
      } on FirebaseException catch (_) {
        Authentication.customSnackBar(
            content: 'Error authenticating user. Try Again!!');
      } catch (e) {
        return null;
      }
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication!.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        userCred = await auth.signInWithCredential(credential);
        // ignore: unused_catch_clause
      } on FirebaseException catch (e) {
        Authentication.customSnackBar(content: 'Error signing in. Try Again!!');
      }
    }

    try {
      signInCred = await userCred!.user!.linkWithCredential(authCred);
      // ignore: unused_catch_clause
    } on FirebaseException catch (e) {
      Authentication.customSnackBar(
          content: 'Error connecting profile. Try Again!!');
    }
    return signInCred!.user;
  }

  static Future<User?> signInWithCredential(
      AuthCredential authCred, BuildContext context) async {
    User? user;
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(authCred);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        final List<String> emailList =
            await auth.fetchSignInMethodsForEmail(e.email!);
        if (emailList.first == 'google.com') {
          user = await Authentication.linkingAccounts(
              emailList.first, e.credential!, e.email);
        }
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error occurred while verifying credentials. Try again.',
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error occurred using Sign In. Try again.',
        ),
      );
    }

    return user;
  }

  Future<User?> signInWithTwitter({required BuildContext context}) async {
    User? user;
    final TwitterLoginCred twitterLoginCred = TwitterLoginCred();
    TwitterLoginResult? twitterAuthResult;
    try {
      twitterAuthResult = await twitterLoginCred.twitterLogin.authorize();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Twitter : Error occurred authorizing. Try again.',
        ),
      );
    }

    AuthCredential authCred;
    switch (twitterAuthResult!.status) {
      case TwitterLoginStatus.loggedIn:
        authCred = TwitterAuthProvider.credential(
            accessToken: twitterAuthResult.session.token!.toString(),
            secret: twitterAuthResult.session.secret!.toString());

        user = await Authentication.signInWithCredential(authCred, context);
        if (user == null) {
          Authentication.customSnackBar(
              content: 'Error signing in user. Try Again!!');
        }
        break;
      case TwitterLoginStatus.cancelledByUser:
        break;
      case TwitterLoginStatus.error:
        // ignore: avoid_print
        print('twitter error : ${TwitterLoginStatus.error.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Twitter: Error occurred while logging in. Try again.',
          ),
        );
        break;
      case null:
        break;
    }

    if (user != null && await isNewUser(user)) {
      createUser(user);
    }
    return user;
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

        user = await Authentication.signInWithCredential(credential, context);
        if (user == null) {
          Authentication.customSnackBar(
              content: 'Error signing in user. Try Again!!');
        }
      }
    }

    if (user != null && await isNewUser(user)) {
      createUser(user);
    }

    return user;
  }

  /// TODO: Clicking off google accounts screen breaks stuff.

  /// SIGN OUT of Google
  static Future<void> signOutOfGoogle({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }

    Future<dynamic>.delayed(const Duration(milliseconds: 1000));

    Navigator.pushNamedAndRemoveUntil(
        context, '/sign_in', (Route<dynamic> route) => false);
  }

  void authCheck(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/sign_in', (Route<dynamic> route) => false);
    }
  }
}
