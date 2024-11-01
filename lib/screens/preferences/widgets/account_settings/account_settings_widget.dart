import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/screens/preferences/widgets/account_settings/account_details_column.dart';
import 'package:little_victories/screens/preferences/widgets/account_settings/display_name_widget.dart';
import 'package:little_victories/widgets/common/loading.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  late Stream<User?> _data;
  final TextEditingController _displayNameController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _data = FirebaseAuth.instance.userChanges();
    _displayNameController.text = _getDisplayName();
  }

  String _getDisplayName() {
    String _name = 'friend';
    if (FirebaseAuth.instance.currentUser!.displayName != null) {
      _name = FirebaseAuth.instance.currentUser!.displayName!.split(' ')[0];
    }
    return _name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      height: 400,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<User?>(
            stream: _data,
            builder: (
              BuildContext context,
              AsyncSnapshot<User?> snapshot,
            ) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Loading();
                case ConnectionState.done:
                  return _buildAccountDetailsList(snapshot);
                case ConnectionState.none:
                  return const Loading();
                case ConnectionState.active:
                  return _buildAccountDetailsList(snapshot);

                default:
                  if (snapshot.hasError) {
                    return const Center(
                      child:
                          Text('Something went wrong, please try again later.'),
                    );
                  } else {
                    return _buildAccountDetailsList(snapshot);
                  }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailsList(dynamic snapshot) {
    return FadeIn(
      duration: const Duration(seconds: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AccountDetailsColumn(
            title: 'Email',
            subtitle: snapshot.data.email ?? '',
          ),
          const SizedBox(height: 20.0),
          AccountDetailsColumn(
            title: 'Joined on',
            subtitle: DateFormat('EEEE, MMM d, yyyy').format(
              snapshot.data.metadata.creationTime,
            ),
          ),
          const SizedBox(height: 20.0),
          DisplayNameWidget(
            form: _form,
            textController: _displayNameController,
            focusNode: _focusNode,
          ),
        ],
      ),
    );
  }
}
