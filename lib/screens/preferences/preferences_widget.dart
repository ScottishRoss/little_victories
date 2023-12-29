import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:little_victories/screens/preferences/widgets/reminders/reminder_preferences.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/widgets/common/custom_back_button.dart';

class PreferencesWidget extends StatefulWidget {
  const PreferencesWidget({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final ValueChanged<int> callback;

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
    <String, dynamic>{
      'index': 1,
      'title': 'Account Settings',
      'subtitle': 'Change your account settings',
      'icon': Icons.person,
      'widget': const Placeholder(),
    },
    <String, dynamic>{
      'index': 2,
      'title': 'Victory Data',
      'subtitle': 'View your victory data',
      'icon': Icons.analytics,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height * 0.62,
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
              return _preferencesList[index]['widget'] ?? const SizedBox();
            },
            groupBy: (dynamic element) => element['index'],
            floatingHeader: true,
            order: GroupedListOrder.ASC,
          ),
        ),
        CustomBackButton(
          callback: widget.callback,
        ),
      ],
    );
  }
}
