import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/extensions.dart';
import 'package:little_victories/widgets/delete_victory_modal.dart';
import 'package:little_victories/widgets/share_victory_modal.dart';

class Victory extends StatefulWidget {
  const Victory({
    Key? key,
    required this.docId,
    required this.victory,
    required this.user,
  }) : super(key: key);

  final String docId;
  final QueryDocumentSnapshot<Object?>? victory;
  final User user;

  @override
  State<Victory> createState() => _VictoryState();
}

class _VictoryState extends State<Victory> {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );

  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = GlobalKey();

  late Timestamp timestamp;
  late DateTime date;
  late String time;
  late String victoryString;
  late String truncatedString;
  late String formattedDate;
  late String? iconName;
  late String docId;

  late Map<String?, dynamic> data;

  IconData getIcon(String iconName) {
    switch (iconName) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'tree':
        return Icons.park;
      case 'food':
        return Icons.restaurant;
      case 'exercise':
        return Icons.fitness_center;
      case 'heart':
        return Icons.favorite;
      case 'people':
        return Icons.groups;
      default:
        return Icons.sentiment_very_satisfied;
    }
  }

  @override
  void initState() {
    // ignore: cast_nullable_to_non_nullable
    data = widget.victory!.data() as Map<String?, dynamic>;
    docId = widget.docId;
    timestamp = data['createdOn'] as Timestamp;
    date = timestamp.toDate();
    time = DateFormat('hh:mm a').format(date);
    victoryString = data['victory'] as String;
    truncatedString = victoryString.truncate(30);
    iconName = data['icon'] as String? ?? 'happy';
    formattedDate = DateFormat('EEEE, MMMM dd yyyy').format(date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: ExpansionTileCard(
        key: cardA,
        elevation: 10,
        baseColor: CustomColours.darkPurple,
        expandedColor: CustomColours.darkPurple,
        expandedTextColor: Colors.white,
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            getIcon(iconName!),
            color: Colors.white,
          ),
        ),
        title: Text(formattedDate),
        subtitle: Text(truncatedString),
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Divider(
              thickness: 1.0,
              height: 1.0,
              color: CustomColours.teal,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                victoryString,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 16),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            buttonHeight: 52.0,
            buttonMinWidth: 90.0,
            children: <Widget>[
              Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () => showDialog<Widget>(
                        context: context,
                        builder: (BuildContext context) {
                          return DeleteVictoryBox(
                            docId: docId,
                            user: widget.user,
                          );
                        }),
                    icon: const FaIcon(
                      FontAwesomeIcons.trashAlt,
                      color: Colors.redAccent,
                    ),
                  ),
                  const Text('Delete'),
                  const SizedBox(height: 5),
                ],
              ),
              Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () => showDialog<Widget>(
                      context: context,
                      builder: (BuildContext context) {
                        return ShareVictoryModal(
                          victory: victoryString,
                        );
                      },
                    ),
                    icon: const FaIcon(
                      FontAwesomeIcons.shareAlt,
                      color: CustomColours.teal,
                    ),
                  ),
                  const Text('Share'),
                  const SizedBox(height: 5),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
