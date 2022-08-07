import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/common/custom_toast.dart';

/// Google

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  final FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? buildCircleProgressIndicator()
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                final User _user =
                    await Authentication().signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (_user != null) {
                  print(_user);
                  Navigator.pushReplacementNamed(
                    context,
                    '/homeFromSignIn',
                  );
                } else {
                  fToast.showToast(
                    child: const CustomToast(
                        message: 'Sign-in failed, please try again later.'),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: const Duration(seconds: 2),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Image(
                      image: AssetImage('assets/google_logo.png'),
                      height: 35.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class SaveVictoryButton extends StatefulWidget {
  const SaveVictoryButton({
    Key? key,
    required User user,
    required String victory,
    required String icon,
  })  : _user = user,
        _victory = victory,
        _icon = icon,
        super(key: key);

  final User _user;
  final String _victory;
  final String _icon;

  @override
  _SaveVictoryButtonState createState() => _SaveVictoryButtonState();
}

class _SaveVictoryButtonState extends State<SaveVictoryButton> {
  bool _isSuccess = false;
  late User _user;
  late String _victory;
  late String _icon;

  @override
  void initState() {
    _user = widget._user;
    _victory = widget._victory;
    _icon = widget._icon;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isSuccess
          ? buildCircleProgressIndicator()
          : TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                _isSuccess = await saveLittleVictory(_user, _victory, _icon);

                if (_isSuccess) {
                  Navigator.pushNamed(context, '/preferences',
                      arguments: _user);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'Celebrate a Victory',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.celebration, size: 10)
                ],
              ),
            ),
    );
  }
}
