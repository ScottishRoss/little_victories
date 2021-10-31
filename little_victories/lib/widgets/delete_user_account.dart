import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/firestore_operations.dart';
import '../res/custom_colours.dart';
import '../util/authentication.dart';
import 'sign_out_of_google_modal.dart';
import '../util/authentication.dart';

class DeleteUserAccount extends StatefulWidget {
  const DeleteUserAccount({Key? key}) : super(key: key);

  @override
  _DeleteUserAccountState createState() => _DeleteUserAccountState();
}

class _DeleteUserAccountState extends State<DeleteUserAccount> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
    ;
  }

  Stack contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            left: Constants.padding,
            top: 10,
            right: Constants.padding,
            bottom: Constants.padding,
          ),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[
                CustomColours.lightPurple,
                CustomColours.teal,
              ],
            ),
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: const <BoxShadow>[
              BoxShadow(offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              Positioned(
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: Constants.avatarRadius,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Constants.avatarRadius)),
                      child: Image.asset('assets/lv_logo_transparent.png')),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                    'Are you sure you want to delete your Little Victories account?',
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(this.context).pop();
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      bool _accountDeleted = false;
                      Navigator.of(context).pop();
                      final String userId = Authentication.fetchingUserID;
                      final bool deleted = await deleteUserAccount(userId);
                      if (deleted) {
                        Authentication.signOutOfGoogle(context: context);

                        try {
                          await FirebaseAuth.instance.currentUser!.delete();
                          _accountDeleted = true;
                        } catch (e) {
                          print('error in deleting account: $e');
                        }
                      }
                      if (_accountDeleted) {
                        Authentication.customSnackBar(
                            content: 'Account Deleted Successfully!!');
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        const Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.close, size: 20, color: Colors.white)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
