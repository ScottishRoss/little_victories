import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        .orderBy('CreatedOn', descending: true)
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
                                  // Specify a key if the Slidable is dismissible.
                                  key: const ValueKey<int>(0),

                                  // The start action pane is the one at the left or the top side.
                                  startActionPane: ActionPane(
                                    // A motion is a widget used to control how the pane animates.
                                    motion: const ScrollMotion(),

                                    // A pane can dismiss the Slidable.
                                    dismissible:
                                        DismissiblePane(onDismissed: () {}),

                                    // All actions are defined in the children parameter.
                                    children: <SlidableAction>[
                                      // A SlidableAction can have an icon and/or a label.
                                      SlidableAction(
                                        onPressed: doNothing,
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                      SlidableAction(
                                        onPressed: doNothing,
                                        backgroundColor:
                                            const Color(0xFF21B7CA),
                                        foregroundColor: Colors.white,
                                        icon: Icons.share,
                                        label: 'Share',
                                      ),
                                    ],
                                  ),

                                  // The end action pane is the one at the right or the bottom side.
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: <SlidableAction>[
                                      SlidableAction(
                                        // An action can be bigger than the others.
                                        flex: 2,
                                        onPressed: doNothing,
                                        backgroundColor:
                                            const Color(0xFF7BC043),
                                        foregroundColor: Colors.white,
                                        icon: Icons.archive,
                                        label: 'Archive',
                                      ),
                                      SlidableAction(
                                        onPressed: doNothing,
                                        backgroundColor:
                                            const Color(0xFF0392CF),
                                        foregroundColor: Colors.white,
                                        icon: Icons.save,
                                        label: 'Save',
                                      ),
                                    ],
                                  ),

                                  // The child of the Slidable is what the user sees when the
                                  // component is not dragged.
                                  child:
                                      const ListTile(title: Text('Slide me')),
                                ),
                                // child: Slidable(
                                //   controller: _slidableController,
                                //   key: ValueKey<int>(index),
                                //   actionPane: const SlidableDrawerActionPane(),
                                //   actions: <Widget>[
                                //     Padding(
                                //       padding: const EdgeInsets.all(5.0),
                                //       child: IconSlideAction(
                                //         caption: 'Twitter',
                                //         color: Colors.blue,
                                //         icon: Icons.share,
                                //         onTap: () => SocialShare.shareTwitter(
                                //           decodedString,
                                //           hashtags: <String>['LittleVictories'],
                                //           url:
                                //               'https://www.littlevictories.app/',
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                //   secondaryActions: <Widget>[
                                //     Padding(
                                //       padding: const EdgeInsets.all(5.0),
                                //       child: IconSlideAction(
                                //         caption: 'Delete',
                                //         color: Colors.red,
                                //         icon: Icons.delete,
                                //         onTap: () => showDialog<Widget>(
                                //           context: context,
                                //           builder: (BuildContext context) {
                                //             return DeleteVictoryBox(
                                //                 docId: victory.id);
                                //           },
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                //   child: Card(
                                //     elevation: 10,
                                //     margin: const EdgeInsets.all(10.0),
                                //     color: getRandomColor(),
                                //     child: ListTile(
                                //       title: Text(decodedString.toString()),
                                //       subtitle: Text(formattedDate.toString()),
                                //     ),
                                //   ),
                                // ),
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
