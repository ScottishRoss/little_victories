import 'package:flutter/material.dart';
import 'package:little_victories/util/custom_colours.dart';

class SignInBackground extends StatelessWidget {
  const SignInBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  CustomColours.darkBlue,
                  CustomColours.darkBlue,
                  CustomColours.teal,
                ],
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
