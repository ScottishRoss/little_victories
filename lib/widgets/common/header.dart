import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/custom_colours.dart';

import '../../util/constants.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .26,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/heart-cloud.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 20.0,
              bottom: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Hello',
                    textAlign: TextAlign.left,
                    style: kTitleTextStyle,
                  ),
                ),
                StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.userChanges(),
                  builder:
                      (BuildContext context, AsyncSnapshot<User?> snapshot) {
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
                        if (snapshot.hasData) {
                          return FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              snapshot.data!.displayName!.split(' ')[0],
                              textAlign: TextAlign.left,
                              style: kTitleTextStyle.copyWith(
                                color: CustomColours.darkBlue,
                                fontSize: 62.0,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.fade,
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      case ConnectionState.done:
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            FirebaseAuth.instance.currentUser!.displayName!
                                .split(' ')[0],
                            textAlign: TextAlign.left,
                            style: kTitleTextStyle.copyWith(
                              color: CustomColours.darkBlue,
                              fontSize: 62.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
