import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/custom_colours.dart';

import '../../util/constants.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String firstName =
      FirebaseAuth.instance.currentUser!.displayName!.split(' ')[0];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .11,
      margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Hello',
              textAlign: TextAlign.left,
              style: kTitleText,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              firstName,
              textAlign: TextAlign.left,
              style: kTitleText.copyWith(
                color: CustomColours.newDarkPurple,
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}
