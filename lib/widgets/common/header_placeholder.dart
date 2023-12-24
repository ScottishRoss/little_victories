import 'package:flutter/material.dart';

class HeaderPlaceholder extends StatelessWidget {
  const HeaderPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .26,
    );
  }
}
