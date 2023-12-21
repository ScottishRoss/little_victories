import 'package:flutter/material.dart';

import '../../util/constants.dart';
import '../../util/custom_colours.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton(
    this.text,
    this.onPressed, {
    Key? key,
    this.backgroundColor = CustomColours.darkBlue,
    this.borderColor = CustomColours.darkBlue,
    this.textColor = Colors.white,
    this.marginBottom = 15,
    this.marginLeft = 25,
    this.marginRight = 25,
    this.marginTop = 15,
  }) : super(key: key);

  final String text;
  final Function() onPressed;
  Color backgroundColor, textColor, borderColor;
  double marginTop, marginBottom, marginLeft, marginRight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(kButtonBorderRadius),
      child: Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(
          marginLeft,
          marginTop,
          marginRight,
          marginBottom,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kButtonBorderRadius),
          color: backgroundColor,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
