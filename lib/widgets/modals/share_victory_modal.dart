import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/util/firebase_analytics.dart';
import 'package:little_victories/util/utils.dart';
import 'package:social_share/social_share.dart';

import 'share_image.dart';

// ignore: must_be_immutable
class ShareVictoryModal extends StatefulWidget {
  ShareVictoryModal({Key? key, this.victory}) : super(key: key);

  String? victory = 'I celebrated a Little Victory!';

  @override
  State<ShareVictoryModal> createState() => _ShareVictoryModalState();
}

class _ShareVictoryModalState extends State<ShareVictoryModal> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10.0),
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
              BoxShadow(offset: Offset(0, 10), blurRadius: 10),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: kModalAvatarRadius,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(kModalAvatarRadius),
                  ),
                  child: Image.asset('assets/lv_logo_transparent.png'),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Share your Victory with your friends',
              textAlign: TextAlign.center,
              textScaleFactor: 1.5,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    SocialShare.shareTwitter(widget.victory!,
                        hashtags: <String>['LittleVictories']);
                    FirebaseAnalyticsService()
                        .logEvent('share_victory', <String, Object>{
                      'platform': 'twitter',
                    });
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.twitter,
                    size: 30.0,
                  ),
                ),
                IconButton(
                  onPressed: () => showDialog<Widget>(
                      context: context,
                      builder: (BuildContext context) {
                        return ShareImage(
                          victory: widget.victory!,
                          platform: 'Facebook',
                        );
                      }),
                  icon: const FaIcon(
                    FontAwesomeIcons.facebook,
                    size: 30.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    SocialShare.shareWhatsapp(widget.victory!);
                    FirebaseAnalyticsService()
                        .logEvent('share_victory', <String, Object>{
                      'platform': 'whatsapp',
                    });
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.whatsapp,
                    size: 30.0,
                  ),
                ),
                IconButton(
                  onPressed: () => showDialog<Widget>(
                      context: context,
                      builder: (BuildContext context) {
                        return ShareImage(
                          victory: widget.victory!,
                          platform: 'Instagram',
                        );
                      }),
                  icon: const FaIcon(
                    FontAwesomeIcons.instagram,
                    size: 30.0,
                  ),
                ),
                IconButton(
                  onPressed: () => showDialog<Widget>(
                      context: context,
                      builder: (BuildContext context) {
                        return ShareImage(
                          victory: widget.victory!,
                          platform: 'Other',
                        );
                      }),
                  icon: const FaIcon(
                    FontAwesomeIcons.shareNodes,
                    size: 30.0,
                  ),
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
