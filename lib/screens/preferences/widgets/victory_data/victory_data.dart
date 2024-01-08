import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations/firestore_victories.dart';
import 'package:little_victories/util/constants.dart';

class VictoryData extends StatefulWidget {
  const VictoryData({Key? key}) : super(key: key);

  @override
  State<VictoryData> createState() => _VictoryDataState();
}

class _VictoryDataState extends State<VictoryData> {
  late Future<AggregateQuerySnapshot> _victoriesData;
  @override
  void initState() {
    super.initState();
    _victoriesData = getVictoriesAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FutureBuilder<AggregateQuerySnapshot>(
            future: _victoriesData,
            builder: (
              BuildContext context,
              AsyncSnapshot<AggregateQuerySnapshot> snapshot,
            ) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  return _buildVictoriesDataList(snapshot);
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  return _buildVictoriesDataList(snapshot);

                default:
                  if (snapshot.hasError) {
                    return const Center(
                      child:
                          Text('Something went wrong, please try again later.'),
                    );
                  } else {
                    return _buildVictoriesDataList(snapshot);
                  }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVictoriesDataList(
      AsyncSnapshot<AggregateQuerySnapshot> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _victoryDataRow(
          'Total Victories',
          snapshot.data!.count.toString(),
        ),
      ],
    );
  }
}

Widget _victoryDataRow(
  String title,
  String subtitle,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      AutoSizeText(
        title,
        style: kPreferencesItemStyle,
      ),
      const SizedBox(height: 10.0),
      AutoSizeText(
        subtitle,
        style: kSubtitleStyle.copyWith(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
