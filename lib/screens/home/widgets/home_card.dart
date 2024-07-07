import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    Key? key,
    required this.children,
    this.colour = Colors.white,
    this.widthDivision = 2,
  }) : super(key: key);

  final List<Widget> children;
  final Color colour;
  final int widthDivision;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: colour,
      ),
      padding: const EdgeInsets.all(10.0),
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width / widthDivision,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: children,
      ),
    );
  }
}
