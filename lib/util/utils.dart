// ignore: flutter_style_todos
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';

Widget buildtext(
  String text, {
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  double? textScaleFactor,
}) =>
    Text(
      text,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: fontSize ?? 15,
        fontWeight: fontWeight,
      ),
    );

//

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
    buildScaffoldMessenger(BuildContext context, {String? content}) =>
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: content ??
                'The account already exists with different credentials',
          ),
        );

Widget buildTextFormField(
  TextEditingController controller,
) {
  return TextFormField(
    controller: controller,
    cursorColor: CustomColours.darkPurple,
    textCapitalization: TextCapitalization.sentences,
    autofocus: true,
    maxLength: 100,
    decoration: InputDecoration(
      labelText: 'What was your Victory?',
      labelStyle: const TextStyle(fontSize: 22.0, color: Colors.white),
      fillColor: Colors.greenAccent,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    ),
    style: const TextStyle(fontSize: 18, color: Colors.white),
    validator: (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter something';
      }
      return null;
    },
  );
}

//TODO(Ross): Refactor all this.

Widget buildOutlinedButton({
  required Function() onPressed,
  required String textType,
  Color textColor = Colors.white,
  double textSize = 14,
  IconData? iconData,
  Color backgroundColor = Colors.red,
}) {
  return OutlinedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(backgroundColor),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            width: 2.0,
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
        buildtext(
          textType,
          fontSize: textSize,
          color: textColor,
          fontWeight: FontWeight.w600,
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

Widget buildTextButton({
  double? radius,
  Function()? onPressed,
  Key? key,
  double elevation = 0,
  Widget? child,
}) =>
    TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius!)),
        ),
      ),
      onPressed: onPressed,
      child: Material(
        color: Colors.transparent,
        type: MaterialType.card,
        borderRadius: BorderRadius.circular(radius),
        key: key,
        elevation: elevation,
        child: child,
      ),
    );

Widget buildCircleProgressIndicator({Color? color}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
    ),
  );
}

String generateRandomString() {
  final Random _random = Random();
  const String _availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  final String randomString = List<String>.generate(
      5,
      (int index) =>
          _availableChars[_random.nextInt(_availableChars.length)]).join();

  return randomString;
}
