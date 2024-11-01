import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations/firestore_account.dart';
import 'package:little_victories/util/custom_colours.dart';

import '../../util/constants.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _dataList;

  @override
  void initState() {
    super.initState();
    _dataList = getUserStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _dataList,
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Center(
              child: CircularProgressIndicator(),
            );

          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );

          case ConnectionState.active:
            return _headerWidget(snapshot.data!['displayName'], context);

          case ConnectionState.done:
            return _headerWidget(snapshot.data!['displayName'], context);
        }
      },
    );
  }
}

Widget _headerWidget(
  String displayName,
  BuildContext context,
) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * .26,
    child: Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/heart-cloud.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 20.0,
            bottom: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Hello',
                  textAlign: TextAlign.left,
                  style: kTitleTextStyle,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  displayName,
                  textAlign: TextAlign.left,
                  style: kTitleTextStyle.copyWith(
                    color: CustomColours.darkBlue,
                    fontSize: 62.0,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
