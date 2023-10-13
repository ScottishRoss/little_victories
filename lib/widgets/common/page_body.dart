import 'package:flutter/material.dart';
import 'package:little_victories/util/custom_colours.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: <Color>[
            CustomColours.mediumPurple,
            CustomColours.pink,
            CustomColours.peach,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SafeArea(
          child: LayoutBuilder(builder: (
            BuildContext context,
            BoxConstraints viewportConstraints,
          ) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                  minWidth: viewportConstraints.maxWidth,
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
