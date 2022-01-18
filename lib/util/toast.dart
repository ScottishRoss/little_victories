import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/res/custom_colours.dart';

class LVToast {
  void showToast({
    required String message,
    required ToastGravity gravity,
    required Toast length,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: CustomColours.lightPurple,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void somethingWentWrong() {
    Fluttertoast.showToast(
      msg: 'Something went wrong, please try again later.',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: CustomColours.lightPurple,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
