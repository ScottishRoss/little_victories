import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/constants.dart';

class TagLine extends StatelessWidget {
  const TagLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AutoSizeText(
          'Celebrate your',
          style: kTitleText.copyWith(
            fontSize: 22,
          ),
        ),
        AutoSizeText(
          'Little Victories',
          style: kTitleText.copyWith(
            fontSize: 46,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}
