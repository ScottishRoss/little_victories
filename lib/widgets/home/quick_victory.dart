import 'dart:developer';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_icon_button/loading_icon_button.dart';

import '../../data/firestore_operations.dart';
import '../../util/constants.dart';
import '../../util/custom_colours.dart';

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
  final FocusNode _focusNode = FocusNode();
  final LoadingButtonController _btnController = LoadingButtonController();

  late bool _isHappyPressed = true;
  late bool _isTreePressed = false;
  late bool _isFoodPressed = false;
  late bool _isPeoplePressed = false;
  late bool _isExercisePressed = false;
  late bool _isHeartPressed = false;

  late String icon = 'happy';

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
        bool? _isSaved = false;
        _isSaved = await saveLittleVictory(
          _quickVictoryTextController.text,
          icon,
        );
        log('_isSaved: $_isSaved');

        if (_isSaved) {
          _btnController.success();
          _confettiController.play();
          _quickVictoryTextController.clear();
          _focusNode.unfocus();
          _formKey.currentState!.reset();
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        setState(() {});
        _btnController.reset();
      }
    } else {
      log('submitQuickVictory: form not validated');
      setState(() {});
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            CustomColours.newDarkPurple.withOpacity(0.9),
            CustomColours.newDarkPurple.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.36,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _iconRow,
          _quickVictoryTextBox,
          _quickVictoryButton,
          _quickVictoryConfetti,
        ],
      ),
    );
  }

  Widget get _iconRow {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <IconButton>[
          IconButton(
            color: Colors.red,
            onPressed: () {
              _changeIconColour('happy');
            },
            icon: Icon(
              Icons.sentiment_satisfied_alt,
              color: _isHappyPressed
                  ? kIconRowActiveColour
                  : kIconRowInactiveColour,
              size: _isHappyPressed ? kiconRowActiveSize : kIconRowInactiveSize,
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
              size: _isTreePressed ? kiconRowActiveSize : kIconRowInactiveSize,
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
              size: _isFoodPressed ? kiconRowActiveSize : kIconRowInactiveSize,
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
              size:
                  _isPeoplePressed ? kiconRowActiveSize : kIconRowInactiveSize,
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
              size: _isExercisePressed
                  ? kiconRowActiveSize
                  : kIconRowInactiveSize,
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
              size: _isHeartPressed ? kiconRowActiveSize : kIconRowInactiveSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _quickVictoryTextBox {
    return IntrinsicHeight(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _quickVictoryTextController,
            focusNode: _focusNode,
            cursorColor: CustomColours.newDarkPurple,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.sentences,
            spellCheckConfiguration: const SpellCheckConfiguration(),
            autofocus: false,
            maxLength: 100,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: 'Celebrate a Victory',
              filled: true,
              fillColor: Colors.white.withOpacity(0.9),
              errorStyle: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                letterSpacing: 1.25,
              ),
              counterStyle: const TextStyle(
                fontSize: 12.0,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
              prefixIcon: const Icon(
                Icons.edit,
                color: CustomColours.newDarkPurple,
              ),
              labelStyle: const TextStyle(
                fontSize: 18.0,
                color: CustomColours.newDarkPurple,
                letterSpacing: 2.0,
              ),
              focusColor: CustomColours.peach,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kButtonBorderRadius),
                borderSide: const BorderSide(
                  color: CustomColours.mediumPurple,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kButtonBorderRadius),
                borderSide: const BorderSide(
                  color: CustomColours.newDarkPurple,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kButtonBorderRadius),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 2,
                ),
              ),
            ),
            onTap: () => _focusNode.requestFocus(),
            onTapOutside: (PointerDownEvent event) => _focusNode.unfocus(),
            style: const TextStyle(
              fontSize: 18,
              color: CustomColours.newDarkPurple,
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please enter something';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget get _quickVictoryButton {
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: LoadingButton(
        primaryColor: CustomColours.newDarkPurple,
        borderRadius: kButtonBorderRadius,
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.05,
        resetAfterDuration: true,
        resetDuration: const Duration(seconds: 2),
        completionDuration: const Duration(seconds: 4),
        errorColor: Colors.redAccent,
        successColor: CustomColours.newDarkPurple,
        child: const Text(
          'celebrate',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 5,
          ),
        ),
        onPressed: () => submitQuickVictory(),
        controller: _btnController,
      ),
    );
  }

  Widget get _quickVictoryConfetti {
    return ConfettiWidget(
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
    );
  }
}
