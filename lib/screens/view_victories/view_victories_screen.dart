import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../util/constants.dart';
import '../../util/custom_colours.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/modals/add_victory_modal.dart';
import 'victory.dart';

class ViewVictoriesScreen extends StatefulWidget {
  const ViewVictoriesScreen({Key? key}) : super(key: key);

  @override
  _ViewVictoriesScreenState createState() => _ViewVictoriesScreenState();
}

class _ViewVictoriesScreenState extends State<ViewVictoriesScreen> {
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
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
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
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final QueryDocumentSnapshot<Object?>? victory =
                  snapshot.data?.docs[index];
              final String docId = snapshot.data!.docs[index].id.toString();

              return Victory(
                docId: docId,
                victory: victory,
                user: _user,
              );
            },
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
      decoration: kBackground,
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
                  builder: _buildVictoryList,
                ),
              ),
              const SizedBox(height: 5.0),
              FloatingActionButton(
                backgroundColor: CustomColours.darkPurple,
                onPressed: () {
                  showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return const AddVictoryBox();
                    },
                  );
                },
                child: const Icon(
                  Icons.add,
                  size: 35,
                  color: Colors.white,
                ),
              ),
              CustomButton(
                'Back',
                () => Navigator.pushNamed(
                  context,
                  '/home',
                  arguments: <User>[_user],
                ),
                marginTop: 0,
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
