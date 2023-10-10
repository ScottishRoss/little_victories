import 'package:flutter/material.dart';
import 'package:little_victories/res/custom_colours.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColours.teal,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: child,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
