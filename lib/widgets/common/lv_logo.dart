import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
