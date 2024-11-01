import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/data/firestore_operations/firestore_victories.dart';
import 'package:little_victories/data/victory_class.dart';
import 'package:little_victories/screens/view_victories/widgets/victory_card.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/widgets/common/custom_back_button.dart';
import 'package:little_victories/widgets/common/loading.dart';

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
  final ScrollController _scrollController = ScrollController();
  late Stream<QuerySnapshot<Object?>>? _dataList;

  @override
  void initState() {
    super.initState();
    _dataList = getVictoriesStream();
  }

  Widget _buildVictoryList(
    BuildContext context,
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
  ) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
        return const Loading();

      case ConnectionState.active:
        if (snapshot.hasError) {
          return _error;
        } else {
          if (snapshot.hasData) {
            return _victoryList(snapshot);
          } else {
            return _noVictories;
          }
        }
      case ConnectionState.done:
        if (snapshot.hasError) {
          return _error;
        } else {
          if (snapshot.hasData) {
            return _victoryList(snapshot);
          } else {
            return _noVictories;
          }
        }
      case ConnectionState.none:
        return Center(
          child: Text(
            'No internet connection',
            style: kSubtitleStyle,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.62,
            child: StreamBuilder<QuerySnapshot<Object?>>(
              stream: _dataList,
              builder: _buildVictoryList,
            ),
          ),
          const SizedBox(height: 5.0),
          CustomBackButton(
            callback: widget.callback,
          ),
        ],
      ),
    );
  }

  Widget get _error {
    return Center(
      child: Text(
        'Something went wrong, please try again later.',
        style: kSubtitleStyle,
      ),
    );
  }

  Widget get _noVictories {
    return Center(
      child: Text(
        'No Victories, yet!',
        style: kSubtitleStyle,
      ),
    );
  }

  Widget _victoryList(dynamic snapshot) {
    return FadeIn(
      duration: const Duration(seconds: 1),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.62,
        child: Scrollbar(
          controller: _scrollController,
          child: GroupedListView<QueryDocumentSnapshot<Object?>, DateTime>(
            elements: snapshot.data.docs,
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
              color: CustomColours.hotPink,
              child: Text(
                DateFormat('MMMM yyyy').format(groupByValue),
                textAlign: TextAlign.left,
                style: kSubtitleStyle.copyWith(
                  color: CustomColours.darkBlue,
                ),
              ),
            ),
            indexedItemBuilder: (
              BuildContext context,
              dynamic element,
              int index,
            ) {
              final Victory victory =
                  Victory.convertDocumentToVictory(index, snapshot);

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
  }
}
