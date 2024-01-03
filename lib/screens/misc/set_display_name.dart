import 'package:flutter/material.dart';
import 'package:little_victories/widgets/common/header_placeholder.dart';
import 'package:little_victories/widgets/common/page_body.dart';

class DisplayName extends StatelessWidget {
  const DisplayName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageBody(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          HeaderPlaceholder(),
        ],
      ),
    );
  }
}
