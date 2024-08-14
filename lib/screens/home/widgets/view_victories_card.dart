import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/screens/home/widgets/home_card.dart';

class ViewVictoriesCard extends StatelessWidget {
  const ViewVictoriesCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
      child: const HomeCard(
        children: <Widget>[
          Icon(
            Icons.view_comfortable_outlined,
            color: Colors.black,
            size: 60.0,
          ),
          AutoSizeText(
            'View Victories',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
