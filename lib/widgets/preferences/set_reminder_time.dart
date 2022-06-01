import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/res/secure_storage.dart';

class ReminderTimepickerWidget extends StatefulWidget {
  const ReminderTimepickerWidget({
    Key? key,
    required this.reminderTime,
  }) : super(key: key);

  final String reminderTime;

  @override
  _ReminderTimepickerWidgetState createState() =>
      _ReminderTimepickerWidgetState();
}

class _ReminderTimepickerWidgetState extends State<ReminderTimepickerWidget> {
  late String selectedTime;
  final SecureStorage _secureStorage = SecureStorage();

  String formatTimeOfDay(TimeOfDay tod) {
    final DateTime now = DateTime.now();
    final DateTime dt =
        DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final DateFormat format = DateFormat.jm();
    return format.format(dt);
  }

  Future<void> displayTimeDialog() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      helpText: 'Select a time',
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? Container(),
        );
      },
    );
    if (time != null) {
      setState(() {
        selectedTime = formatTimeOfDay(time);
      });
      print(time);
      _secureStorage.insertIntoSecureStorage(kNotificationTime, selectedTime);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedTime = widget.reminderTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Reminder Time: '),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                selectedTime,
                style: kSubtitleStyle,
              ),
            ),
            ElevatedButton(
              onPressed: () => displayTimeDialog(),
              child: const Text('Change time'),
              style: ElevatedButton.styleFrom(
                primary: CustomColours.darkPurple,
              ),
            ),
          ],
        )
      ],
    );
  }
}
