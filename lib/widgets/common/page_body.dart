import 'package:flutter/material.dart';

import '../../util/custom_colours.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
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
        ),
        Container(
          height: MediaQuery.of(context).size.height * .5,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/watercolor-paint-brush-strokes-from-a-hand-drawn.png',
                ),
                fit: BoxFit.cover),
          ),
        ),
        Scaffold(
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
      ],
    );
  }
}
