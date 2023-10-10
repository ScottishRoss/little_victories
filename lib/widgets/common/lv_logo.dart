import 'package:flutter/material.dart';

class LVLogo extends StatelessWidget {
  const LVLogo({
    Key? key,
    this.isLightMode = true,
  }) : super(key: key);

  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isLightMode
          ? 'assets/lv_logo_transparent.png'
          : 'assets/lv_logo_transparent_dark_purple.png',
      fit: BoxFit.fitWidth,
    );
  }
}
