import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:little_victories/data/firestore_operations/firestore_victories.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/widgets/common/loading.dart';

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
      height: 70,
      child: _buildVictoryDataRow(
        _victoriesData,
      ),
    );
  }

  Widget _buildVictoryDataRow(dynamic snapshot) {
    return FadeIn(
      duration: const Duration(seconds: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const AutoSizeText(
            'Total Victories',
            style: kPreferencesItemStyle,
          ),
          FutureBuilder<AggregateQuerySnapshot>(
            future: _victoriesData,
            builder: (
              BuildContext context,
              AsyncSnapshot<AggregateQuerySnapshot> snapshot,
            ) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Loading(height: 20);
                case ConnectionState.done:
                  return AutoSizeText(
                    snapshot.data!.count.toString(),
                    style: kSubtitleStyle.copyWith(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                case ConnectionState.none:
                  return const Loading();
                case ConnectionState.active:
                  return AutoSizeText(
                    snapshot.data!.count.toString(),
                    style: kSubtitleStyle.copyWith(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );

                default:
                  if (snapshot.hasError) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return AutoSizeText(
                      snapshot.data!.count.toString(),
                      style: kSubtitleStyle.copyWith(
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  }
              }
            },
          ),
        ],
      ),
    );
  }
}
