import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/res/custom_colours.dart';

class CustomToast extends StatefulWidget {
  const CustomToast({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  State<CustomToast> createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast> {
  late FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: CustomColours.teal,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            child: Image.asset('assets/lv_logo_transparent_purple.png'),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Text(widget.message),
        ],
      ),
    );
  }
}
