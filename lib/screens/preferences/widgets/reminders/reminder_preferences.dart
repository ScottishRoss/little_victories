import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/data/notifications_class.dart';
import 'package:little_victories/screens/preferences/widgets/reminders/reminders_switch_widget.dart';
import 'package:little_victories/screens/preferences/widgets/reminders/reminders_timepicker_widget.dart';

class ReminderPreferences extends StatefulWidget {
  const ReminderPreferences({Key? key}) : super(key: key);

  @override
  State<ReminderPreferences> createState() => _ReminderPreferencesState();
}

class _ReminderPreferencesState extends State<ReminderPreferences> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _dataList;

  @override
  void initState() {
    super.initState();
    _dataList = getNotificationsStream();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _dataList,
            builder: (
              BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
            ) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  return _buildNotificationsList(snapshot);
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  return _buildNotificationsList(snapshot);

                default:
                  if (snapshot.hasError) {
                    return const Center(
                      child:
                          Text('Something went wrong, please try again later.'),
                    );
                  } else {
                    return _buildNotificationsList(snapshot);
                  }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(dynamic snapshot) {
    final Notifications notificationsData =
        Notifications.fromMap(snapshot.data.data());
    return Column(
      children: <Widget>[
        RemindersSwitchWidget(
          notificationsData: notificationsData,
        ),
        ReminderTimepickerWidget(
          notificationsData: notificationsData,
        ),
      ],
    );
  }
}
