import 'package:flutter/material.dart';
import 'package:little_victories/screens/home/widgets/home_button_card.dart';
import 'package:little_victories/screens/home/widgets/quick_victory.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final ValueChanged<int> callback;

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          QuickVictory(formKey: formKey),
          GestureDetector(
            onTap: () => callback(1),
            child: const HomeButtonCard(
              image: 'windows.jpg',
              title: 'Preferences',
            ),
          ),
          GestureDetector(
            onTap: () => callback(2),
            child: const HomeButtonCard(
              image: 'confetti.jpg',
              title: 'Your Victories',
            ),
          ),
        ],
      ),
    );
  }
}
