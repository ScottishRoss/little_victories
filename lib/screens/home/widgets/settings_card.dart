import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/screens/home/widgets/home_card.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
      child: HomeCard(
        widthDivision: 3,
        children: <Widget>[
          const Icon(
            Icons.app_settings_alt_outlined,
            color: Colors.black,
            size: 60.0,
          ),
          settingsText(),
        ],
      ),
    );
  }
}

Widget settingsText() {
  return const AutoSizeText(
    'Settings',
    style: TextStyle(
      fontSize: 22,
    ),
  );
}
