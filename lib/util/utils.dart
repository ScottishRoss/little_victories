import 'dart:math';

import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/authentication.dart';
import 'package:little_victories/widgets/nice_buttons.dart';

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

Widget buildNiceButton(
  String text,
  Color backgroundColor,
  Function() onPressed, {
  List<Color>? gradientColors,
  Color textColor = Colors.white,
  double? radius,
  double? fontSize,
  double marginTop = 15.0,
  double marginBottom = 15.0,
  double marginLeft = 15.0,
  double marginRight = 15.0,
}) =>
    Container(
      margin: EdgeInsets.fromLTRB(
        marginLeft,
        marginTop,
        marginRight,
        marginBottom,
      ),
      child: NiceButton(
        textColor: textColor,
        width: double.infinity,
        fontSize: fontSize ?? 18.0,
        elevation: 10.0,
        radius: radius ?? 52.0,
        text: text,
        background: backgroundColor,
        onPressed: onPressed,
        gradientColors: gradientColors ?? <Color>[],
      ),
    );

Widget buildFlexibleImage({
  int? flex,
  double? height,
}) =>
    Flexible(
      flex: flex ?? 4,
      child: Image.asset(
        'assets/lv_main.png',
        height: height ?? 400,
      ),
    );

BoxDecoration boxDecoration({
  List<Color>? colors,
  BorderRadiusGeometry? borderRadius,
  List<BoxShadow>? boxShadow,
  AlignmentGeometry? end,
}) =>
    BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: end ?? Alignment.bottomRight,
        colors: colors ??
            <Color>[
              CustomColours.darkPurple,
              CustomColours.teal,
            ],
      ),
      boxShadow: boxShadow ??
          <BoxShadow>[
            const BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 10,
            ),
          ],
    );

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

Widget buildOutlinedButton(
        {Function()? onPressed,
        String? textType,
        Color? textColor,
        double? textSize,
        IconData? iconData,
        MaterialStateProperty<Color?>? backgroundColor}) =>
    OutlinedButton(
      style: ButtonStyle(
        backgroundColor:
            backgroundColor ?? MaterialStateProperty.all(Colors.redAccent),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildtext(
            textType!,
            fontSize: textSize,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
          Icon(
            iconData,
            size: 20,
            color: Colors.white,
          ),
        ],
      ),
    );

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
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
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
