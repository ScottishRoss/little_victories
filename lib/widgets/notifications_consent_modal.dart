import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/res/constants.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/res/secure_storage.dart';
import 'package:little_victories/util/utils.dart';

class NotificationsConsentModal extends StatefulWidget {
  const NotificationsConsentModal({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationsConsentModalState createState() =>
      _NotificationsConsentModalState();
}

class _NotificationsConsentModalState extends State<NotificationsConsentModal> {
  bool _isSuccess = false;
  final AwesomeNotifications _notifications = AwesomeNotifications();
  final SecureStorage _secureStorage = SecureStorage();

  late String? _isNotificationsOn;

  void getNotificationsStatus() async {
    _isNotificationsOn =
        await _secureStorage.getFromSecureStorage('is_notifications_on');
    print('Notifications status: $_isNotificationsOn');
  }

  @override
  void initState() {
    getNotificationsStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kModalPadding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(kModalPadding),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[
              CustomColours.lightPurple,
              CustomColours.teal,
            ],
          ),
          borderRadius: BorderRadius.circular(kModalPadding),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: MediaQuery.of(context).size.height * 0.075,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(kModalAvatarRadius),
                  ),
                  child: Image.asset('assets/lv_logo_transparent.png'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Do you want to turn on reminders?',
              textAlign: TextAlign.center,
              textScaleFactor: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Turning on reminders will help you build a habit of celebrating Little Victories. This can be changed at any time.',
              textAlign: TextAlign.center,
              textScaleFactor: 1.25,
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    _secureStorage.insertIntoSecureStorage(
                      'is_notifications_on',
                      'false',
                    );
                    Navigator.pop(context);
                  },
                  child: buildtext(
                    'No thanks',
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Container(
                  child: _isSuccess
                      ? buildCircleProgressIndicator()
                      : buildOutlinedButton(
                          textType: 'Yes, please!',
                          iconData: Icons.check,
                          textColor: Colors.white,
                          textSize: 15,
                          backgroundColor: MaterialStateProperty.all(
                            CustomColours.darkPurple,
                          ),
                          onPressed: () async {
                            setState(() {
                              _isSuccess = true;
                            });
                            _notifications
                                .isNotificationAllowed()
                                .then((bool _isAllowed) {
                              if (!_isAllowed) {
                                AwesomeNotifications()
                                    .requestPermissionToSendNotifications();
                              }

                              _secureStorage.insertIntoSecureStorage(
                                'is_notifications_on',
                                _isAllowed.toString(),
                              );
                              Navigator.pop(context);
                            });
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
