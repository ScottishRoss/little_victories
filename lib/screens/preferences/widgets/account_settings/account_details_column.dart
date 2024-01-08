import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/constants.dart';

class AccountDetailsColumn extends StatelessWidget {
  const AccountDetailsColumn({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AutoSizeText(
          title,
          style: kPreferencesItemStyle,
        ),
        const SizedBox(height: 10.0),
        AutoSizeText(
          subtitle,
          style: kSubtitleStyle.copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
