import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/data/victory_class.dart';
import 'package:little_victories/screens/view_victories/victory_card.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/widgets/common/custom_back_button.dart';

class ViewVictoriesWidget extends StatefulWidget {
  const ViewVictoriesWidget({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final ValueChanged<int> callback;

  @override
  _ViewVictoriesWidgetState createState() => _ViewVictoriesWidgetState();
}

class _ViewVictoriesWidgetState extends State<ViewVictoriesWidget> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  late Stream<QuerySnapshot<Object?>>? _dataList;
  late User _user;

  Victory convertDocumentToVictory(
    int index,
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
  ) {
    final QueryDocumentSnapshot<Object?>? result = snapshot.data?.docs[index];

    return Victory.fromDocument(result!);
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _dataList = getVictoriesStream(_user.uid);
  }

  Widget _buildVictoryList(
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
            child: Text('Something went wrong, please try again later.'),
          );
        } else if (snapshot.data!.docs.isNotEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.62,
            child: Scrollbar(
              controller: _scrollController,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.white,
                      Colors.transparent,
                    ],
                    stops: <double>[0.9, 1],
                  ).createShader(bounds);
                },
                child:
                    GroupedListView<QueryDocumentSnapshot<Object?>, DateTime>(
                  elements: snapshot.data!.docs,
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  cacheExtent: 50,
                  groupBy: (dynamic element) {
                    final Timestamp timestamp = element['createdOn'];
                    final DateTime date = timestamp.toDate();

                    return DateTime(date.year, date.month);
                  },
                  groupSeparatorBuilder: (DateTime groupByValue) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 5.0,
                    ),
                    width: double.infinity,
                    color: CustomColours.darkBlue,
                    child: Text(
                      DateFormat('MMMM yyyy').format(groupByValue),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  indexedItemBuilder: (
                    BuildContext context,
                    dynamic element,
                    int index,
                  ) {
                    final Victory victory =
                        convertDocumentToVictory(index, snapshot);

                    return VictoryCard(
                      victory: victory,
                    );
                  },
                  useStickyGroupSeparators: true,
                  floatingHeader: true,
                  order: GroupedListOrder.DESC,
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No Victories, yet!',
              style: TextStyle(fontSize: 18.0),
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot<Object?>>(
            stream: _dataList,
            builder: _buildVictoryList,
          ),
          const SizedBox(height: 5.0),
          CustomBackButton(
            callback: widget.callback,
          ),
        ],
      ),
    );
  }
}
