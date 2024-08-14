import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations/firestore_victories.dart';
import 'package:little_victories/screens/home/widgets/home_card.dart';
import 'package:little_victories/util/custom_colours.dart';

class VictoriesCounter extends StatefulWidget {
  const VictoriesCounter({Key? key}) : super(key: key);

  @override
  State<VictoriesCounter> createState() => _VictoriesCounterState();
}

class _VictoriesCounterState extends State<VictoriesCounter> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _data;

  @override
  void initState() {
    super.initState();
    _data = getVictoryCountStream();
  }

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      widthDivision: 2.25,
      colour: CustomColours.peach,
      children: <Widget>[
        victoriesText(),
        victoriesStreambuilder(_data),
      ],
    );
  }
}

Widget victoriesStreambuilder(Stream<QuerySnapshot<Object?>> _data) {
  return StreamBuilder<QuerySnapshot<Object?>>(
    stream: _data,
    builder: _buildVictoriesCount,
  );
}

Widget victoriesText() {
  return const Text(
    'Victories',
    style: TextStyle(
      fontSize: 22,
    ),
  );
}

Widget _buildVictoriesCount(
  BuildContext context,
  AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
) {
  switch (snapshot.connectionState) {
    case ConnectionState.waiting:
      return const Center(
        child: CircularProgressIndicator(),
      );
    default:
      if (snapshot.hasError) {
        log('Error: ${snapshot.error}');
        return const Center(
          child: Text('ERROR'),
        );
      } else if (snapshot.data!.docs.isNotEmpty) {
        return AutoSizeText(
          snapshot.data!.size.toString(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 52.0),
        );
      } else {
        return const Center(
          child: Text(
            '0',
            style: TextStyle(fontSize: 52.0),
          ),
        );
      }
  }
}
