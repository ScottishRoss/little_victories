import 'package:flutter/material.dart';
import 'package:little_victories/data/icon_list.dart';
import 'package:little_victories/data/victory_class.dart';

class VictoryCard extends StatelessWidget {
  const VictoryCard({
    Key? key,
    required this.victory,
  }) : super(key: key);

  final Victory victory;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(getIconData(victory.icon)),
        title: Text(victory.victory),
      ),
    );
  }
}
