import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/utils.dart';

class DeleteAccountBox extends StatefulWidget {
  const DeleteAccountBox({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _DeleteAccountBoxState createState() => _DeleteAccountBoxState();
}

class _DeleteAccountBoxState extends State<DeleteAccountBox> {
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kModalPadding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(this.context),
    );
  }

  Stack contentBox(BuildContext context) {
    assert(context != null);
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            left: kModalPadding,
            top: 10,
            right: kModalPadding,
            bottom: kModalPadding,
          ),
          margin: const EdgeInsets.only(top: kModalAvatarRadius),
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
              BoxShadow(offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: kModalAvatarRadius,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(kModalAvatarRadius),
                  ),
                  child: Image.asset('assets/lv_logo_transparent.png'),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: const <Widget>[
                  Text(
                    'Are you sure you want to delete your account?',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.5,
                  ),
                  Text(
                    'All your Victories will be lost.',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.5,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(this.context).pop();
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 15, color: Colors.white),
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
                            backgroundColor:
                                MaterialStateProperty.all(Colors.redAccent),
                            onPressed: () async {
                              setState(() {
                                _isSuccess = true;
                              });
                              await deleteUser(_user);

                              Navigator.pushNamedAndRemoveUntil(context,
                                  '/sign_in', (Route<dynamic> route) => false);
                            },
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
