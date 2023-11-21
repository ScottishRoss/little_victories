import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/common/custom_button.dart';
import 'victory.dart';

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
          return SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final QueryDocumentSnapshot<Object?>? victory =
                    snapshot.data?.docs[index];
                final String docId = snapshot.data!.docs[index].id.toString();

                log(victory![index].data().toString());

                return VictoryCard(
                  docId: docId,
                  victory: victory,
                  user: _user,
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
