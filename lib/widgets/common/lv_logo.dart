import 'package:flutter/material.dart';

class LVLogo extends StatelessWidget {
  const LVLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/lv_main.png',
      fit: BoxFit.fitWidth,
    );
  }
}
