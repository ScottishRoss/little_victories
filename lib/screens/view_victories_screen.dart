import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/utils.dart';

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

  late User _user;

  @override
  void initState() {
    _user = widget._user;
    _dataList = firestore
        .collection('victories')
        .where('UserId', isEqualTo: _user.uid)
        .orderBy('CreatedOn', descending: false)
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
              Expanded(
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
                        } else if (!snapshot.hasData ||
                            snapshot.data?.docs == null) {
                          return const Center(
                            child: Text('No Victories to show'),
                          );
                        } else {
                          return GroupedListView<Element, DateTime>(
                            elements: List<Element>.generate(
                              snapshot.data!.docs.length,
                              (int index) {
                                final QueryDocumentSnapshot<Object?>? victory =
                                    snapshot.data?.docs[index];
                                final Timestamp timestamp =
                                    victory!['CreatedOn'] as Timestamp;
                                final DateTime date = timestamp.toDate();
                                final String decodedString =
                                    victory['Victory'].toString();

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
                                TransactionGroupSeparator(date: date),
                            order: GroupedListOrder.DESC,
                            itemBuilder:
                                (BuildContext context, dynamic element) {
                              final DateTime time = element.date as DateTime;
                              final String formattedDate =
                                  DateFormat.Hm().format(time);
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Card(
                                  color: CustomColours.darkPurple,
                                  elevation: 10.0,
                                  child: Container(
                                    margin: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        const SizedBox(width: 20.0),
                                        Expanded(
                                          child: Text(
                                            element.victory.toString(),
                                            softWrap: true,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                    }
                  },
                ),
              ),
              buildNiceButton(
                'Back',
                CustomColours.darkPurple,
                () => Navigator.pushNamed(context, '/home',
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

mixin StickyGroupedListOrder {}

class Element {
  Element(this.date, this.victory);
  DateTime date;
  String victory;
}

class TransactionGroupSeparator extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const TransactionGroupSeparator({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
        child: Text(
          DateFormat.yMMMMd().format(date),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
