import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/firebase_analytics.dart';
import 'package:little_victories/util/utils.dart';
import 'package:social_share/social_share.dart';

import 'share_image.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

// ignore: must_be_immutable
class ShareVictoryModal extends StatelessWidget {
  ShareVictoryModal({Key? key, required this.user, this.victory})
      : super(key: key);

  final User user;
  String? victory = 'I celebrated a Little Victory!';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Stack contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 300,
          padding: const EdgeInsets.only(
            left: Constants.padding,
            top: 10,
            right: Constants.padding,
            bottom: Constants.padding,
          ),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[
                  CustomColours.lightPurple,
                  CustomColours.teal,
                ],
              ),
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: const <BoxShadow>[
                BoxShadow(offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Share your Victory with your friends'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      SocialShare.shareTwitter(victory!,
                          hashtags: <String>['LittleVictories']);
                      FirebaseAnalyticsService()
                          .logEvent('share_victory', <String, Object>{
                        'platform': 'twitter',
                      });
                    },
                    icon: const FaIcon(FontAwesomeIcons.twitter),
                  ),
                  IconButton(
                    onPressed: () => showDialog<Widget>(
                        context: context,
                        builder: (BuildContext context) {
                          return ShareImage(
                            victory: victory!,
                            platform: 'Facebook',
                          );
                        }),
                    icon: const FaIcon(FontAwesomeIcons.facebook),
                  ),
                  IconButton(
                    onPressed: () {
                      SocialShare.shareWhatsapp(victory!);
                      FirebaseAnalyticsService()
                          .logEvent('share_victory', <String, Object>{
                        'platform': 'whatsapp',
                      });
                    },
                    icon: const FaIcon(FontAwesomeIcons.whatsapp),
                  ),
                  IconButton(
                    onPressed: () => showDialog<Widget>(
                        context: context,
                        builder: (BuildContext context) {
                          return ShareImage(
                            victory: victory!,
                            platform: 'Instagram',
                          );
                        }),
                    icon: const FaIcon(FontAwesomeIcons.instagram),
                  ),
                  IconButton(
                    onPressed: () => showDialog<Widget>(
                        context: context,
                        builder: (BuildContext context) {
                          return ShareImage(
                            victory: victory!,
                            platform: 'Other',
                          );
                        }),
                    icon: const FaIcon(FontAwesomeIcons.shareAlt),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: buildtext(
                      'Close',
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 60,
          left: 30,
          right: 30,
          child: Center(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Constants.avatarRadius)),
                child: Image.asset('assets/lv_logo_transparent.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget shareImage(String victory) {
  return SizedBox(
    width: 1080,
    height: 1920,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Image.asset('assets/facebook_story.png'),
        Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                victory,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30.0,
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    ),
  );
}
