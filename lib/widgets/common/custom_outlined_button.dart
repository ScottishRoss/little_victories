import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.textColor = Colors.white,
    this.textSize = 14,
    this.iconData,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  final Function() onPressed;
  final String text;
  final Color textColor;
  final double textSize;
  final IconData? iconData;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              width: 0.0,
              color: textColor,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: textSize,
            ),
          ),
          if (iconData != null)
            Icon(
              iconData,
              size: 20,
              color: textColor,
            ),
        ],
      ),
    );
  }
}
