import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, this.height = 100}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
