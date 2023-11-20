import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/firestore_operations.dart';
import '../../util/constants.dart';
import '../../util/custom_colours.dart';
import '../../util/utils.dart';

class ManageAccountModal extends StatefulWidget {
  const ManageAccountModal({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _ManageAccountModalState createState() => _ManageAccountModalState();
}

class _ManageAccountModalState extends State<ManageAccountModal> {
  late User _user;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _user = widget.user;

    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kModalPadding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(kModalPadding),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[
              CustomColours.lightPurple,
              CustomColours.teal,
            ],
          ),
          borderRadius: BorderRadius.circular(kModalPadding),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: MediaQuery.of(context).size.height * 0.075,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(kModalAvatarRadius),
                  ),
                  child: Image.asset('assets/lv_logo_transparent.png'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Are you sure you want to delete your account?',
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(1.5),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'All your Victories will be lost.',
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(1.5),
              style: TextStyle(
                color: CustomColours.darkPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(this.context).pop();
                  },
                  child: buildtext(
                    'Close',
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Container(
                  child: _isSuccess
                      ? buildCircleProgressIndicator()
                      : buildOutlinedButton(
                          textType: 'Delete Account',
                          iconData: Icons.delete_forever,
                          textColor: Colors.white,
                          textSize: 15,
                          backgroundColor: CustomColours.darkPurple,
                          onPressed: () async {
                            setState(() {
                              _isSuccess = true;
                            });
                            await deleteUser(_user);

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/sign_in',
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
