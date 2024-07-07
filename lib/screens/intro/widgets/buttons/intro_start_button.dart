import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/custom_colours.dart';

class IntroStartButton extends StatelessWidget {
  const IntroStartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowRadiusFactor: 40,
      glowColor: CustomColours.hotPink,
      child: const Text(
        'Start',
        style: TextStyle(
          color: CustomColours.darkBlue,
          fontSize: 24,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
