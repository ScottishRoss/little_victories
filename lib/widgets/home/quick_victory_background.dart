import 'package:flutter/material.dart';

class QuickVictoryBackground extends StatelessWidget {
  const QuickVictoryBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/watercolor-paint-brush-strokes-from-a-hand-drawn.png',
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.transparent, Colors.white],
                  stops: <double>[0, 10])),
        ),
      ],
    );
  }
}
