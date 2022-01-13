import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/share_victory_modal.dart';

class ViewVictoriesScreen extends StatefulWidget {
  const ViewVictoriesScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _ViewVictoriesScreenState createState() => _ViewVictoriesScreenState();
}

class _ViewVictoriesScreenState extends State<ViewVictoriesScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Object?>>? _dataList;
  final ScrollController scrollController = ScrollController();

  late User _user;

  @override
  void initState() {
    _user = widget._user;
    _dataList = firestore
        .collection('users')
        .doc(_user.uid)
        .collection('victories')
        .orderBy('createdOn', descending: false)
        .snapshots();

    super.initState();
  }

  void doNothing(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20.0),
                child: const Text(
                  'Your Victories',
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: StreamBuilder<QuerySnapshot<Object?>>(
                  stream: _dataList,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
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
                          return RawScrollbar(
                            thumbColor: CustomColours.teal,
                            controller: scrollController,
                            isAlwaysShown: true,
                            radius: const Radius.circular(20),
                            thickness: 5,
                            child: GroupedListView<Element, DateTime>(
                              elements: List<Element>.generate(
                                snapshot.data!.docs.length,
                                (int index) {
                                  final QueryDocumentSnapshot<Object?>?
                                      victory = snapshot.data?.docs[index];
                                  final Timestamp timestamp =
                                      victory!['createdOn'] as Timestamp;
                                  final DateTime date = timestamp.toDate();
                                  final String decodedString =
                                      victory['victory'].toString();

                                  return Element(date, decodedString);
                                },
                              ),
                              groupBy: (Element element) {
                                return DateTime(
                                  element.date.year,
                                  element.date.month,
                                  element.date.day,
                                );
                              },
                              groupSeparatorBuilder: (DateTime date) =>
                                  DateSeparator(date: date),
                              order: GroupedListOrder.DESC,
                              separator: const Divider(
                                color: CustomColours.darkPurple,
                                thickness: 1.0,
                              ),
                              itemBuilder:
                                  (BuildContext context, dynamic element) {
                                final DateTime time = element.date as DateTime;
                                final String formattedDate =
                                    DateFormat.Hm().format(time);

                                return _viewVictoryRow(
                                  formattedDate,
                                  element.victory.toString(),
                                  context,
                                  _user,
                                );
                              },
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
                  },
                ),
              ),
              buildNiceButton(
                'Back',
                CustomColours.darkPurple,
                () => Navigator.pushNamed(context, '/homeFromViewVictories',
                    arguments: <User>[_user]),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _viewVictoryRow(
    String date, String victory, BuildContext context, User _user) {
  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 10.0,
    ),
    child: IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            width: MediaQuery.of(context).size.width / 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          const VerticalDivider(
            color: Colors.white,
            thickness: 2.0,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              victory,
              softWrap: true,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          const VerticalDivider(
            color: Colors.white,
            thickness: 2.0,
          ),
          SizedBox(
            width: 30.0,
            child: Column(
              children: <IconButton>[
                IconButton(
                  onPressed: () => showDialog<Widget>(
                      context: context,
                      builder: (BuildContext context) {
                        return ShareVictoryModal(
                          user: _user,
                          victory: victory,
                        );
                      }),
                  icon: const FaIcon(
                    FontAwesomeIcons.trashAlt,
                    color: Colors.redAccent,
                  ),
                ),
                IconButton(
                  onPressed: () => showDialog<Widget>(
                      context: context,
                      builder: (BuildContext context) {
                        return ShareVictoryModal(
                          user: _user,
                          victory: victory,
                        );
                      }),
                  icon: const FaIcon(
                    FontAwesomeIcons.shareAlt,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

mixin StickyGroupedListOrder {}

class Element {
  Element(this.date, this.victory);
  DateTime date;
  String victory;
}

class DateSeparator extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const DateSeparator({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              right: 30,
              top: 5.0,
              bottom: 5.0,
            ),
            child: Text(
              DateFormat.yMMMMd().format(date),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColours.darkPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
