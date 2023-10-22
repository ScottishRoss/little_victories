import 'package:flutter/material.dart';
import '../../util/constants.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .1,
      margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Hello',
            textAlign: TextAlign.left,
            style: kTitleText,
          ),
          Text(
            widget.name,
            textAlign: TextAlign.left,
            style: kTitleText,
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    );
  }
}
