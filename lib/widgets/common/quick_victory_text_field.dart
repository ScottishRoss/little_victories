import 'package:flutter/material.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';

class QuickVictoryTextField extends StatefulWidget {
  const QuickVictoryTextField({
    Key? key,
    this.callback,
  }) : super(key: key);

  final Function? callback;

  @override
  State<QuickVictoryTextField> createState() => _HomeQuickVictoryState();
}

class _HomeQuickVictoryState extends State<QuickVictoryTextField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Celebrate your Victory',
            hintStyle: const TextStyle(
              color: CustomColours.darkPurple,
            ),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kButtonBorderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
