import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/widgets/common/header.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  CustomColours.darkBlue,
                  CustomColours.darkBlue,
                  CustomColours.teal,
                  CustomColours.hotPink,
                  CustomColours.hotPink,
                ],
              ),
            ),
          ),
          const Header(),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              log('StreamBuilder: ${snapshot.connectionState}');
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Center(
                    child: Text(
                      'No internet connection, please check your network settings.',
                    ),
                  );

                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                case ConnectionState.active:
                  log(snapshot.data.toString());
                  if (snapshot.hasData) {
                    return LayoutBuilder(builder: (
                      BuildContext context,
                      BoxConstraints viewportConstraints,
                    ) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                          minWidth: viewportConstraints.maxWidth,
                        ),
                        child: child,
                      );
                    });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return LayoutBuilder(builder: (
                      BuildContext context,
                      BoxConstraints viewportConstraints,
                    ) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                          minWidth: viewportConstraints.maxWidth,
                        ),
                        child: child,
                      );
                    });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                default:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
