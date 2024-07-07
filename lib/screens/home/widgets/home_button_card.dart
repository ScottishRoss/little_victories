import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HomeButtonCard extends StatelessWidget {
  const HomeButtonCard({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.elliptical(
            15,
            30,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AutoSizeText(
          title,
          style: const TextStyle(
            fontSize: 38,
            height: 0.8,
          ),
        ),
      ),
    );
  }
}
