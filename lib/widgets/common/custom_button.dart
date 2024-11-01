import 'dart:developer';

import 'package:flutter/material.dart';

import '../../util/constants.dart';
import '../../util/custom_colours.dart';

// ignore: must_be_immutable
class CustomButton extends StatefulWidget {
  CustomButton(
    this.text,
    this.onPressed, {
    Key? key,
    this.backgroundColor = CustomColours.teal,
    this.borderColor = CustomColours.teal,
    this.textColor = CustomColours.darkBlue,
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
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isProcessing = true;
          log('CustomButton: _isProcessing = $_isProcessing');
        });

        widget.onPressed();

        setState(() {
          _isProcessing = false;
          log('CustomButton: _isProcessing = $_isProcessing');
        });
      },
      borderRadius: BorderRadius.circular(kButtonBorderRadius),
      child: Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(
          widget.marginLeft,
          widget.marginTop,
          widget.marginRight,
          widget.marginBottom,
        ),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kButtonBorderRadius),
          color: widget.backgroundColor,
        ),
        alignment: Alignment.center,
        child: _isProcessing
            ? const CircularProgressIndicator()
            : Text(
                widget.text,
                style: kSubtitleStyle.copyWith(
                  color: CustomColours.darkBlue,
                ),
              ),
      ),
    );
  }
}
