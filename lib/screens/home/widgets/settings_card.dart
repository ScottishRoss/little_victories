import 'package:flutter/material.dart';
import 'package:little_victories/screens/home/widgets/home_card.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      widthDivision: 3,
      children: <Widget>[
        settingsText(),
        const Icon(
          Icons.app_settings_alt_outlined,
          color: Colors.black,
          size: 60.0,
        ),
      ],
    );
  }
}

Widget settingsText() {
  return const Text(
    'Settings',
    style: TextStyle(
      fontSize: 22,
    ),
  );
}
