import 'dart:developer';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/util/utils.dart';
import 'package:lottie/lottie.dart';

class QuickVictory extends StatefulWidget {
  const QuickVictory({
    Key? key,
  }) : super(key: key);

  @override
  State<QuickVictory> createState() => _QuickVictoryState();
}

class _QuickVictoryState extends State<QuickVictory> {
  final TextEditingController _quickVictoryTextController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  late bool _isHappyPressed = true;
  late bool _isTreePressed = false;
  late bool _isFoodPressed = false;
  late bool _isPeoplePressed = false;
  late bool _isExercisePressed = false;
  late bool _isHeartPressed = false;

  bool _isSuccess = false;

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
  }

  Future<void> submitQuickVictory() async {
    log('submitQuickVictory: validating form');
    if (_formKey.currentState!.validate()) {
      log('submitQuickVictory: form validated');
      try {
        log('submitQuickVictory: saving victory');
        await saveLittleVictory(
          _quickVictoryTextController.text,
          icon,
        );

        setState(() {
          _isSuccess = true;
        });

        _confettiController.play();

        setState(() {
          _isSuccess = false;
        });
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      log('submitQuickVictory: form not validated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.275,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.bottomLeft,
          colors: <Color>[
            CustomColours.newDarkPurple,
            CustomColours.brightPurple,
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Lottie.asset('assets/circle_city.json'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _quickVictoryTextController,
                      cursorColor: CustomColours.peach,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textCapitalization: TextCapitalization.sentences,
                      autofocus: false,
                      maxLength: 100,
                      decoration: InputDecoration(
                        labelText: 'What was your Victory?',
                        counterText: '',
                        labelStyle: const TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                        ),
                        fillColor: Colors.greenAccent,
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(kButtonBorderRadius),
                          borderSide: const BorderSide(
                            color: CustomColours.peach,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(kButtonBorderRadius),
                          borderSide: const BorderSide(
                            color: CustomColours.peach,
                            width: 2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(kButtonBorderRadius),
                          borderSide: const BorderSide(
                            color: CustomColours.pink,
                            width: 2,
                          ),
                        ),
                      ),
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter something';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <IconButton>[
                  IconButton(
                    color: Colors.red,
                    onPressed: () {
                      _changeIconColour('happy');
                    },
                    icon: Icon(
                      Icons.sentiment_very_satisfied,
                      color: _isHappyPressed
                          ? kIconRowActiveColour
                          : kIconRowInactiveColour,
                      size: _isHappyPressed ? 30 : 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _changeIconColour('tree');
                    },
                    icon: Icon(
                      Icons.park,
                      color: _isTreePressed
                          ? kIconRowActiveColour
                          : kIconRowInactiveColour,
                      size: _isTreePressed ? 30 : 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _changeIconColour('food');
                    },
                    icon: Icon(
                      Icons.restaurant,
                      color: _isFoodPressed
                          ? kIconRowActiveColour
                          : kIconRowInactiveColour,
                      size: _isFoodPressed ? 30 : 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _changeIconColour('people');
                    },
                    icon: Icon(
                      Icons.groups,
                      color: _isPeoplePressed
                          ? kIconRowActiveColour
                          : kIconRowInactiveColour,
                      size: _isPeoplePressed ? 30 : 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _changeIconColour('exercise');
                    },
                    icon: Icon(
                      Icons.fitness_center,
                      color: _isExercisePressed
                          ? kIconRowActiveColour
                          : kIconRowInactiveColour,
                      size: _isExercisePressed ? 30 : 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _changeIconColour('heart');
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: _isHeartPressed
                          ? kIconRowActiveColour
                          : kIconRowInactiveColour,
                      size: _isHeartPressed ? 30 : 20,
                    ),
                  ),
                ],
              ),
              Container(
                child: _isSuccess
                    ? buildCircleProgressIndicator()
                    : buildOutlinedButton(
                        textType: 'Celebrate a Victory',
                        iconData: Icons.celebration,
                        backgroundColor: Colors.transparent,
                        onPressed: () async {
                          await submitQuickVictory();
                        }),
              ),
              ConfettiWidget(
                blastDirectionality: BlastDirectionality.explosive,
                confettiController: _confettiController,
                emissionFrequency: 0,
                numberOfParticles: 30,
                gravity: 0.05,
                colors: const <Color>[
                  CustomColours.brightPurple,
                  CustomColours.newDarkPurple,
                  CustomColours.pink,
                  CustomColours.peach,
                  Colors.white,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
