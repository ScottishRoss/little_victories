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
      color: CustomColours.teal,
      child: ListTile(
        leading: Icon(getIconData(victory.icon)),
        title: Text(victory.victory),
        subtitle: Text(victory.createdOn),
      ),
    );
  }
}
