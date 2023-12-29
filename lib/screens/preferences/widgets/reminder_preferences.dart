import 'package:flutter/material.dart';
import 'package:little_victories/data/notifications_class.dart';
import 'package:little_victories/screens/preferences/widgets/reminders_switch_widget.dart';
import 'package:little_victories/screens/preferences/widgets/reminders_timepicker_widget.dart';
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
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 8.0,
          ),
          Text(
            'Reminders',
            style: kTitleText.copyWith(
              fontSize: 24.0,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
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
                  return _buildNotificationsRow(snapshot);
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return _buildNotificationsRow(snapshot);
                  }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsRow(dynamic snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
