import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';

class LittleVictories extends StatelessWidget {
  const LittleVictories({
    Key? key,
    this.variant = NameVariant.dark,
  }) : super(key: key);

  final NameVariant? variant;

  Color _variantColour() {
    switch (variant) {
      case NameVariant.dark:
        return Colors.white;
      case NameVariant.light:
        return CustomColours.darkBlue;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 40, 0, 0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AutoSizeText(
            'Little ',
            style: kTitleTextStyle.copyWith(
              letterSpacing: 2.0,
              color: _variantColour(),
              fontWeight: FontWeight.w400,
              fontSize: 60,
            ),
          ),
          Row(
            children: <Widget>[
              AutoSizeText(
                'Victories',
                style: kTitleTextStyle.copyWith(
                  letterSpacing: 2.0,
                  color: CustomColours.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                ),
              ),
              AutoSizeText(
                '.',
                style: kTitleTextStyle.copyWith(
                  letterSpacing: 2.0,
                  color: _variantColour(),
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

enum NameVariant {
  light,
  dark,
}
