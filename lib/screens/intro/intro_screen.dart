// ignore_for_file: avoid_field_initializers_in_const_classes

import 'package:flutter/material.dart';
import 'package:little_victories/widgets/common/lv_logo.dart';
import 'package:little_victories/widgets/common/page_body.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageBody(
      child: Column(
        children: const <Widget>[
          // Little Victories Logo
          LVLogo(),

          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
