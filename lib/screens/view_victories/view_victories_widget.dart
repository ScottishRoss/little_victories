import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/data/victory_class.dart';
import 'package:little_victories/screens/view_victories/victory_card.dart';
import 'package:little_victories/util/custom_colours.dart';

import '../../widgets/common/custom_button.dart';

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
  late Stream<QuerySnapshot<Object?>>? _dataList;
  late User _user;

  Victory convertDocumentToVictory(
      int index, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    final QueryDocumentSnapshot<Object?>? result = snapshot.data?.docs[index];

    return Victory.fromDocument(result!);
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _dataList = _getVictoriesStream(_user.uid);
  }

  Stream<QuerySnapshot<Object?>> _getVictoriesStream(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('victories')
        .orderBy('createdOn', descending: true)
        .snapshots();
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
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.data!.docs.isNotEmpty) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: <Color>[
                  CustomColours.darkBlue,
                  CustomColours.darkBlue.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.55,
            child: GroupedListView<dynamic, String>(
              elements: snapshot.data!.docs,
              groupBy: (dynamic element) {
                final DateTime createdOn = element['createdOn'].toDate();
                final String formattedDate =
                    DateFormat('MMMM yyyy').format(createdOn);

                return formattedDate;
              },
              groupSeparatorBuilder: (String groupByValue) =>
                  Text(groupByValue),
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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          StreamBuilder<QuerySnapshot<Object?>>(
            stream: _dataList,
            builder: _buildVictoryList,
          ),
          const SizedBox(height: 5.0),
          CustomButton(
            'Back',
            () => widget.callback(0),
          ),
        ],
      ),
    );
  }
}
