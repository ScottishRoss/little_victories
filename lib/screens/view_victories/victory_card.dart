import 'package:flutter/material.dart';
import 'package:little_victories/data/icon_list.dart';
import 'package:little_victories/data/victory_class.dart';
import 'package:little_victories/util/custom_colours.dart';

class VictoryCard extends StatelessWidget {
  const VictoryCard({
    Key? key,
    required this.victory,
  }) : super(key: key);

  final Victory victory;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      color: CustomColours.darkBlue.withOpacity(0.7),
      child: ListTile(
        leading: Icon(
          getIconData(victory.icon),
          size: 40,
          color: Colors.white,
        ),
        title: Text(
          victory.victory,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(victory.createdOn),
      ),
    );
  }
}
