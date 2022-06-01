import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:little_victories/res/constants.dart';

class ReminderTimepickerWidget extends StatefulWidget {
  const ReminderTimepickerWidget({Key? key}) : super(key: key);

  @override
  _ReminderTimepickerWidgetState createState() =>
      _ReminderTimepickerWidgetState();
}

class _ReminderTimepickerWidgetState extends State<ReminderTimepickerWidget> {
  String? selectedTime = '18:00 PM';

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
    }
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
                selectedTime!,
                style: kSubtitleStyle,
              ),
            ),
            ElevatedButton(
              onPressed: () => displayTimeDialog(),
              child: const Text('Change time'),
            ),
          ],
        )
      ],
    );
  }
}
