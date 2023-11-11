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
    return Material(
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * .26,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/heart-cloud.jpg',
                    //'assets/watercolor-paint-brush-strokes-from-a-hand-drawn.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20.0,
                bottom: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Hello',
                      textAlign: TextAlign.left,
                      style: kTitleText.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      firstName,
                      textAlign: TextAlign.left,
                      style: kTitleText.copyWith(
                        color: CustomColours.darkBlue,
                        fontSize: 62.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
