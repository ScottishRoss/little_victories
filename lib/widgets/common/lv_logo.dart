import 'package:flutter/material.dart';

class LVLogo extends StatelessWidget {
  const LVLogo({
    Key? key,
    this.variant = LogoVariant.white,
  }) : super(key: key);

  final LogoVariant? variant;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case LogoVariant.white:
        return Image.asset(
          'assets/logo.png',
          fit: BoxFit.fitWidth,
        );
      case LogoVariant.teal:
        return Image.asset(
          'assets/logo-teal.png',
          fit: BoxFit.fitWidth,
        );
      case LogoVariant.pink:
        return Image.asset(
          'assets/logo-pink.png',
          fit: BoxFit.fitWidth,
        );
      case LogoVariant.dark:
        return Image.asset(
          'assets/logo-dark.png',
          fit: BoxFit.fitWidth,
        );
      default:
        return Image.asset(
          'assets/logo.png',
          fit: BoxFit.fitWidth,
        );
    }
  }
}

enum LogoVariant {
  white,
  teal,
  pink,
  dark,
}
