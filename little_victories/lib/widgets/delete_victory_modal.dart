import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/utils.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double logoRadius = 45;
}

class DeleteVictoryBox extends StatefulWidget {
  const DeleteVictoryBox({Key? key, required String docId})
      : _docId = docId,
        super(key: key);

  final String _docId;

  @override
  _DeleteVictoryBoxState createState() => _DeleteVictoryBoxState();
}

class _DeleteVictoryBoxState extends State<DeleteVictoryBox> {
  late String _docId;
  bool _isSuccess = false;

  @override
  void initState() {
    _docId = widget._docId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(this.context),
    );
  }

  Stack contentBox(BuildContext context) {
    assert(context != null);
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            left: Constants.padding,
            top: 10,
            right: Constants.padding,
            bottom: Constants.padding,
          ),
          margin: const EdgeInsets.only(top: Constants.logoRadius),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[
                CustomColours.lightPurple,
                CustomColours.teal,
              ],
            ),
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: const <BoxShadow>[
              BoxShadow(offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Positioned(
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: Constants.logoRadius,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Constants.logoRadius),
                    ),
                    child: Image.asset('assets/lv_logo_transparent.png'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: const <Widget>[
                  Text(
                    'Are you sure you want to delete this Victory?',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.5,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(this.context).pop();
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    child: _isSuccess
                        ? buildCircleProgressIndicator()
                        : buildOutlinedButton(
                            textType: 'Delete Victory',
                            iconData: Icons.delete_forever,
                            textColor: Colors.white,
                            textSize: 15,
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onPressed: () async {
                              await deleteLittleVictory(_docId.toString());
                              setState(() {
                                _isSuccess = true;
                              });
                              Navigator.of(this.context).pop();
                            },
                          ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
