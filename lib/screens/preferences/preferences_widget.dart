import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:little_victories/screens/preferences/widgets/reminders/reminder_preferences.dart';
import 'package:little_victories/util/constants.dart';

import '../../data/firestore_operations.dart';
import '../../util/custom_colours.dart';
import '../../util/utils.dart';

class PreferencesWidget extends StatefulWidget {
  const PreferencesWidget({Key? key}) : super(key: key);

  @override
  _PreferencesWidgetState createState() => _PreferencesWidgetState();
}

class _PreferencesWidgetState extends State<PreferencesWidget> {
  final List<Map<String, dynamic>> _preferencesList = <Map<String, dynamic>>[
    <String, dynamic>{
      'index': 0,
      'title': 'Reminders',
      'subtitle': 'Set reminders to keep you on track',
      'icon': Icons.notifications,
      'widget': const ReminderPreferences(),
    },
    <String, Object>{
      'index': 1,
      'title': 'Account Settings',
      'subtitle': 'Change your account settings',
      'icon': Icons.person,
      'widget': const Placeholder(),
    },
    <String, Object>{
      'index': 2,
      'title': 'Victory Data',
      'subtitle': 'View your victory data',
      'icon': Icons.analytics,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: GroupedListView<dynamic, dynamic>(
          elements: _preferencesList.toList(),
          groupHeaderBuilder: (dynamic element) => Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              element['title'] as String,
              style: kTitleText.copyWith(
                fontSize: 24.0,
              ),
            ),
          ),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          cacheExtent: 50,
          indexedItemBuilder: (
            BuildContext context,
            dynamic element,
            int index,
          ) {
            return _preferencesList[index]['widget'] ?? const Placeholder();
          },
          groupBy: (dynamic element) => element['index'],
          floatingHeader: true,
          order: GroupedListOrder.ASC,
        ),

        // child: ListView(
        //   padding: EdgeInsets.zero,
        //   children: <Widget>[
        //     Container(
        //       color: CustomColours.darkBlue,
        //       child: Text(
        //         'Preferences',
        //         style: kTitleText.copyWith(
        //           fontSize: 24.0,
        //         ),
        //       ),
        //     ),
        //     const ReminderPreferences(),
        //     CustomButton(
        //       'Delete Account',
        //       () {
        //         showDialog<Widget>(
        //           context: context,
        //           builder: (BuildContext context) {
        //             return CustomModal(
        //               title: 'Delete Victory',
        //               desc: 'Are you sure you want to delete this Victory?',
        //               button: _deleteAccountButton(),
        //             );
        //           },
        //         );
        //       },
        //       marginBottom: 0,
        //       backgroundColor: Colors.red.shade400,
        //       borderColor: Colors.red.shade400,
        //     ),
        //     CustomButton(
        //       'Sign Out',
        //       () => showDialog<Widget>(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return const SignOutOfGoogleBox();
        //         },
        //       ),
        //     ),
        //     CustomButton(
        //       'Back',
        //       () => Navigator.pushNamed(
        //         context,
        //         '/home',
        //       ),
        //     ),
        //     const SizedBox(height: 20.0),
        //   ],
        // ),
      ),
    );
  }

  Widget _deleteAccountButton() {
    return buildOutlinedButton(
        textType: 'Delete Account',
        iconData: Icons.delete_forever,
        textSize: 15,
        backgroundColor: CustomColours.darkPurple,
        onPressed: () async {
          await deleteUser();

          Navigator.pushNamedAndRemoveUntil(
              context, '/sign_in', (Route<dynamic> route) => false);
        });
  }
}
