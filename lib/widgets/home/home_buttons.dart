import 'package:flutter/material.dart';
import 'package:little_victories/widgets/home/home_button_card.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .5,
      child: const Column(
        children: <Widget>[
          HomeButtonCard(
            image: 'windows.jpg',
            title: 'Preferences',
          ),
          HomeButtonCard(
            image: 'confetti.jpg',
            title: 'Your Victories',
          ),
        ],
      ),
    );
  }
}
