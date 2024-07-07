import 'package:flutter/material.dart';
import 'package:little_victories/util/custom_colours.dart';

class IntroBackButton extends StatelessWidget {
  const IntroBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Back',
      style: TextStyle(
        color: CustomColours.darkBlue,
        fontSize: 18,
        letterSpacing: 1.5,
      ),
    );
  }
}
