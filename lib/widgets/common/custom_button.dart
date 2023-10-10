import 'package:flutter/material.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton(
    this.text,
    this.onPressed, {
    Key? key,
    this.backgroundColor = CustomColours.darkPurple,
    this.borderColor = CustomColours.teal,
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kButtonBorderRadius),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        marginLeft,
        marginTop,
        marginRight,
        marginBottom,
      ),
      child: Material(
        elevation: 10,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(kButtonBorderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(kButtonBorderRadius),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kButtonBorderRadius),
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
        ),
      ),
    );
  }
}
