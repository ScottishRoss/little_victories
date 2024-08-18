import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/screens/preferences/widgets/danger_zone/manage_account_modal.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';

class DangerZone extends StatelessWidget {
  const DangerZone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _dangerZoneRow(
            'Delete account',
            'Delete',
            () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const ManageAccountModal();
                }),
            Icons.delete_forever,
            Colors.redAccent,
            Colors.white,
          ),
          _dangerZoneRow(
            'Sign out',
            'Sign out',
            () => Authentication.signOutOfGoogle(context: context),
            Icons.logout,
            CustomColours.teal,
            CustomColours.darkBlue,
          ),
        ],
      ),
    );
  }
}

Widget _dangerZoneRow(
  String title,
  String buttonText,
  Function() onPressed,
  IconData? icon,
  Color buttonColor,
  Color textColor,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      AutoSizeText(
        title,
        style: kPreferencesItemStyle,
      ),
      ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(buttonText),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
        ),
      )
    ],
  );
}
