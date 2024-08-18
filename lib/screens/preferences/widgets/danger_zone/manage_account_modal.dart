import 'package:flutter/material.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';

import '../../../../data/firestore_operations/firestore_account.dart';

class ManageAccountModal extends StatefulWidget {
  const ManageAccountModal({
    Key? key,
  }) : super(key: key);

  @override
  _ManageAccountModalState createState() => _ManageAccountModalState();
}

class _ManageAccountModalState extends State<ManageAccountModal> {
  bool _isSuccess = false;

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
          color: CustomColours.darkBlue,
          borderRadius: BorderRadius.circular(kModalPadding),
          border: Border.all(
            color: CustomColours.teal,
            width: 2,
          ),
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
                  child: Image.asset(
                    'assets/logo-teal.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Are you sure you want to delete your account?',
              style: kPreferencesItemStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Text(
              'All your Victories will be lost.',
              textAlign: TextAlign.center,
              style: kSubtitleStyle.copyWith(
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(this.context).pop();
                  },
                  child: const Text(
                    'Close',
                    style: kBodyTextStyle,
                  ),
                ),
                Container(
                  child: _isSuccess
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isSuccess = false;
                            });
                            final bool isDeleted = await deleteUser();

                            if (isDeleted) {
                              setState(() {
                                _isSuccess = true;
                              });
                            }

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/sign_in',
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Text(
                            'Yes, delete',
                            style: kPreferencesItemStyle,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
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
