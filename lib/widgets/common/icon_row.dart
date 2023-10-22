import 'package:flutter/material.dart';
import '../../util/custom_colours.dart';

class IconRow extends StatefulWidget {
  const IconRow({Key? key}) : super(key: key);

  @override
  State<IconRow> createState() => _IconRowState();
}

class _IconRowState extends State<IconRow> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <IconButton>[
        IconButton(
          color: Colors.red,
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
    );
  }
}
