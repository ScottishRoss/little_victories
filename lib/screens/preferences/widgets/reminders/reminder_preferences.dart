import 'package:flutter/material.dart';
import 'package:little_victories/data/notifications_class.dart';
import 'package:little_victories/screens/preferences/widgets/reminders/reminders_switch_widget.dart';
import 'package:little_victories/screens/preferences/widgets/reminders/reminders_timepicker_widget.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/secure_storage.dart';

class ReminderPreferences extends StatelessWidget {
  const ReminderPreferences({Key? key}) : super(key: key);

  Future<Notifications> isNotificationsOn() async {
    final String? _notificationsSwitchValue =
        await SecureStorage().getFromKey(kIsNotificationsEnabled);
    final String? _notificationTime =
        await SecureStorage().getFromKey(kNotificationTime);
    final bool _notificationsValueBool =
        _notificationsSwitchValue == 'true' || false;

    return Notifications(
      isNotificationsEnabled: _notificationsValueBool,
      notificationTime: _notificationTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FutureBuilder<Notifications>(
            future: isNotificationsOn(),
            builder:
                (BuildContext context, AsyncSnapshot<Notifications> snapshot) {
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
    return Column(
      children: <Widget>[
        RemindersSwitchWidget(
          notificationsData: snapshot.data!,
        ),
        ReminderTimepickerWidget(
          notificationsData: snapshot.data!,
        ),
      ],
    );
  }
}
