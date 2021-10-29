import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/utils.dart';
import 'package:little_victories/widgets/delete_victory_modal.dart';
import 'package:social_share/social_share.dart';

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
  late final SlidableController _slidableController;
  late Stream<QuerySnapshot<Object?>>? _dataList;

  late User _user;

  @override
  void initState() {
    _user = widget._user;
    _slidableController = SlidableController();
    _dataList = firestore
        .collection('victories')
        .where('UserId', isEqualTo: _user.uid)
        .orderBy('CreatedOn', descending: true)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                          return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final QueryDocumentSnapshot<Object?>? victory =
                                  snapshot.data?.docs[index];
                              final Timestamp timestamp =
                                  victory!['CreatedOn'] as Timestamp;
                              final DateTime date = timestamp.toDate();
                              final String formattedDate =
                                  DateFormat.Hm().add_yMMMMEEEEd().format(date);

                              ///? There must be a cleaner way of doing this date -> string cast.
                              final String decodedString =
                                  victory['Victory'].toString();
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Slidable(
                                  controller: _slidableController,
                                  key: ValueKey<int>(index),
                                  actionPane: const SlidableDrawerActionPane(),
                                  actions: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconSlideAction(
                                        caption: 'Twitter',
                                        color: Colors.blue,
                                        icon: Icons.share,
                                        onTap: () => SocialShare.shareTwitter(
                                          decodedString,
                                          hashtags: <String>['LittleVictories'],
                                          url:
                                              'https://www.littlevictories.app/',
                                        ),
                                      ),
                                    ),
                                  ],
                                  secondaryActions: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconSlideAction(
                                        caption: 'Delete',
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () => showDialog<Widget>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DeleteVictoryBox(
                                                docId: victory.id);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                  child: Card(
                                    elevation: 10,
                                    margin: const EdgeInsets.all(10.0),
                                    color: getRandomColor(),
                                    child: ListTile(
                                      title: Text(decodedString.toString()),
                                      subtitle: Text(formattedDate.toString()),
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
