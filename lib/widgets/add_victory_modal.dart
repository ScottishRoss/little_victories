import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/res/custom_colours.dart';
import 'package:little_victories/util/utils.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class AddVictoryBox extends StatefulWidget {
  const AddVictoryBox({Key? key}) : super(key: key);

  @override
  _AddVictoryBoxState createState() => _AddVictoryBoxState();
}

class _AddVictoryBoxState extends State<AddVictoryBox> {
  late User _user;

  final TextEditingController _victoryController = TextEditingController();
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 3),
  );
  bool _isSuccess = false;

  late bool _isHappyPressed = true;
  late bool _isTreePressed = false;
  late bool _isFoodPressed = false;
  late bool _isPeoplePressed = false;
  late bool _isExercisePressed = false;
  late bool _isHeartPressed = false;

  late String icon;

  void _changeIconColour(String iconName) {
    setState(() {
      icon = iconName;
    });
    switch (iconName) {
      case 'happy':
        setState(() {
          if (_isHappyPressed) {
            _isExercisePressed = false;
            _isFoodPressed = false;
            _isHeartPressed = false;
            _isPeoplePressed = false;
            _isTreePressed = false;
          } else {
            _isHappyPressed = true;
            _isExercisePressed = false;
            _isFoodPressed = false;
            _isHeartPressed = false;
            _isPeoplePressed = false;
            _isTreePressed = false;
          }
        });
        break;
      case 'tree':
        setState(() {
          if (_isTreePressed) {
            _isExercisePressed = false;
            _isFoodPressed = false;
            _isHeartPressed = false;
            _isPeoplePressed = false;
            _isHappyPressed = false;
          } else {
            _isTreePressed = true;
            _isExercisePressed = false;
            _isFoodPressed = false;
            _isHeartPressed = false;
            _isPeoplePressed = false;
            _isHappyPressed = false;
          }
        });
        break;
      case 'food':
        setState(() {
          if (_isFoodPressed) {
            _isExercisePressed = false;
            _isHeartPressed = false;
            _isPeoplePressed = false;
            _isTreePressed = false;
            _isHappyPressed = false;
          } else {
            _isFoodPressed = true;
            _isExercisePressed = false;
            _isHeartPressed = false;
            _isPeoplePressed = false;
            _isTreePressed = false;
            _isHappyPressed = false;
          }
        });
        break;
      case 'people':
        setState(() {
          if (_isPeoplePressed) {
            _isFoodPressed = false;
            _isExercisePressed = false;
            _isHeartPressed = false;
            _isTreePressed = false;
            _isHappyPressed = false;
          } else {
            _isPeoplePressed = true;
            _isFoodPressed = false;
            _isExercisePressed = false;
            _isHeartPressed = false;
            _isTreePressed = false;
            _isHappyPressed = false;
          }
        });
        break;
      case 'exercise':
        setState(() {
          if (_isExercisePressed) {
            _isFoodPressed = false;
            _isHeartPressed = false;
            _isPeoplePressed = false;
            _isTreePressed = false;
            _isHappyPressed = false;
          } else {
            _isExercisePressed = true;
            _isFoodPressed = false;
            _isHeartPressed = false;
            _isPeoplePressed = false;
            _isTreePressed = false;
            _isHappyPressed = false;
          }
        });
        break;
      case 'heart':
        setState(() {
          if (_isHeartPressed) {
            _isFoodPressed = false;
            _isExercisePressed = false;
            _isPeoplePressed = false;
            _isTreePressed = false;
            _isHappyPressed = false;
          } else {
            _isHeartPressed = true;
            _isFoodPressed = false;
            _isExercisePressed = false;
            _isPeoplePressed = false;
            _isTreePressed = false;
            _isHappyPressed = false;
          }
        });
        break;
    }
    print(icon);
  }

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser!;
    icon = 'happy';
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
      child: contentBox(context),
    );
  }

  // ignore: type_annotate_public_apis
  Stack contentBox(BuildContext context) {
    assert(context != null);
    return Stack(
      children: <Widget>[
        Container(
          height: 320,
          padding: const EdgeInsets.only(
            left: Constants.padding,
            top: 10,
            right: Constants.padding,
            bottom: Constants.padding,
          ),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
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
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildTextFormField(_victoryController),
                  ],
                ),
              ),
              ConfettiWidget(
                blastDirectionality: BlastDirectionality.explosive,
                confettiController: _confettiController,
                emissionFrequency: 0,
                numberOfParticles: 30,
                gravity: 0.05,
                colors: const <Color>[
                  CustomColours.lightPurple,
                  CustomColours.darkPurple,
                  CustomColours.teal,
                  Colors.white,
                ],
              ),
              _iconRow(),
              Row(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(this.context).pop();
                    },
                    child: buildtext(
                      'Close',
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    child: _isSuccess
                        ? buildCircleProgressIndicator()
                        : buildOutlinedButton(
                            textType: 'Celebrate a Victory',
                            iconData: Icons.celebration,
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await saveLittleVictory(
                                  _user,
                                  _victoryController.text,
                                  icon,
                                );

                                setState(() {
                                  _isSuccess = true;
                                });

                                _confettiController.play();
                                Future<dynamic>.delayed(
                                    const Duration(seconds: 2), () {
                                  Navigator.of(this.context).pop();
                                });
                              }
                            },
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 60,
          left: 30,
          right: 30,
          child: Center(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(Constants.avatarRadius),
                ),
                child: Image.asset('assets/lv_logo_transparent.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconRow() {
    return SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <IconButton>[
            IconButton(
              onPressed: () {
                _changeIconColour('happy');
              },
              icon: Icon(
                Icons.sentiment_very_satisfied,
                color: _isHappyPressed ? CustomColours.teal : Colors.white,
                size: _isHappyPressed ? 30 : 20,
              ),
            ),
            IconButton(
              onPressed: () {
                _changeIconColour('tree');
              },
              icon: Icon(
                Icons.park,
                color: _isTreePressed ? CustomColours.teal : Colors.white,
                size: _isTreePressed ? 30 : 20,
              ),
            ),
            IconButton(
              onPressed: () {
                _changeIconColour('food');
              },
              icon: Icon(
                Icons.restaurant,
                color: _isFoodPressed ? CustomColours.teal : Colors.white,
                size: _isFoodPressed ? 30 : 20,
              ),
            ),
            IconButton(
              onPressed: () {
                _changeIconColour('people');
              },
              icon: Icon(
                Icons.groups,
                color: _isPeoplePressed ? CustomColours.teal : Colors.white,
                size: _isPeoplePressed ? 30 : 20,
              ),
            ),
            IconButton(
              onPressed: () {
                _changeIconColour('exercise');
              },
              icon: Icon(
                Icons.fitness_center,
                color: _isExercisePressed ? CustomColours.teal : Colors.white,
                size: _isExercisePressed ? 30 : 20,
              ),
            ),
            IconButton(
              onPressed: () {
                _changeIconColour('heart');
              },
              icon: Icon(
                Icons.favorite,
                color: _isHeartPressed ? CustomColours.teal : Colors.white,
                size: _isHeartPressed ? 30 : 20,
              ),
            ),
          ],
        ));
  }
}
