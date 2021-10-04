import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/res/custom_colours.dart';
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
  late Stream<QuerySnapshot>? _dataList;

  late User _user;

  @override
  void initState() {
    _user = widget._user;
    _slidableController = SlidableController();
    _dataList = firestore.collection('victories').where('UserId', isEqualTo: _user.uid).orderBy('CreatedOn', descending: true).snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [CustomColours.darkPurple, CustomColours.teal])),
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: _dataList,
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                default:
                                  if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else
                                  if(!snapshot.hasData || snapshot.data?.docs == null) {
                                    return const Center(child: Text('No Victories to show'));
                                  } else {
                                      return ListView.builder(
                                          itemCount: snapshot.data?.docs.length,
                                          itemBuilder: (context, index) {
                                            final victory = snapshot.data?.docs[index];
                                            final Timestamp timestamp = victory!.data()['CreatedOn'] as Timestamp;
                                            final date = timestamp.toDate();
                                            final formattedDate = DateFormat.Hm()
                                                .add_yMMMMEEEEd()
                                                .format(date);
                                            /// TODO: There must be a cleaner way of doing this date -> string cast.
                                            final String decodedString = victory.data()['Victory'].toString();
                                            return Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Slidable(
                                                  controller: _slidableController,
                                                    key: ValueKey(index),
                                                    actionPane: const SlidableDrawerActionPane(),
                                                    actions: <Widget>[ // ignore: prefer_const_literals_to_create_immutables
                                                      Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: IconSlideAction(
                                                          caption: 'Twitter',
                                                          color: Colors.blue,
                                                          icon: Icons.share,
                                                            onTap: () => SocialShare.shareTwitter(
                                                                decodedString,
                                                                hashtags: ["LittleVictories"],
                                                                url: 'https://www.littlevictories.app/'
                                                            )
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
                                                  onTap: () => showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                    return DeleteVictoryBox(docId: victory.id);
                                                  })
                                                )
                                              )
                                            ],
                                            child: Card(
                                                color: getRandomColor(),
                                                child: ListTile(
                                                  title: Text(decodedString.toString()),
                                                  subtitle: Text(formattedDate.toString()),
                                                ))));
                                          });
                                      }
                              }
                              })
                    )
                )
            )
        )
    );
  }
}
