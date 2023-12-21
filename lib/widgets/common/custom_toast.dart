import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../util/custom_colours.dart';

class CustomToast extends StatelessWidget {
  const CustomToast({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: CustomColours.darkBlue,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            child: Image.asset('assets/lv_logo_transparent.png'),
            backgroundColor: Colors.transparent,
          ),
          AutoSizeText(
            message,
            style: const TextStyle(
              color: CustomColours.teal,
            ),
          ),
        ],
      ),
    );
  }
}
