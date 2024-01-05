import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations/firestore_victories.dart';
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
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: CustomColours.teal,
            title: const Text(
              'Delete Victory',
              style: TextStyle(
                color: CustomColours.darkBlue,
                letterSpacing: 1.5,
              ),
            ),
            content: const Text(
              'Are you sure you want to delete this victory?',
              style: TextStyle(
                color: CustomColours.darkBlue,
                fontSize: 18,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: CustomColours.darkBlue,
                    fontSize: 16,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  await deleteLittleVictory(victory.docId);
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: CustomColours.darkBlue,
                  ),
                ),
                child: const Text(
                  'Yes, delete',
                  style: TextStyle(
                    color: CustomColours.darkBlue,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      child: Card(
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
      ),
    );
  }
}
