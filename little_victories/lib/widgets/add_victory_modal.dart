import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  const AddVictoryBox({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _AddVictoryBoxState createState() => _AddVictoryBoxState();
}

class _AddVictoryBoxState extends State<AddVictoryBox> {
  late User _user;

  final TextEditingController _victoryController = TextEditingController();
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 3));
  // ignore: prefer_typing_uninitialized_variables
  bool _isSuccess = false;

  @override
  void initState() {
    _user = widget._user;
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
          height: 300,
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
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: <BoxShadow>[
                const BoxShadow(offset: Offset(0, 10), blurRadius: 10),
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
              const Expanded(child: VictoryCategory()),
              ConfettiWidget(
                blastDirectionality: BlastDirectionality.explosive,
                confettiController: _confettiController,
                emissionFrequency: 0,
                numberOfParticles: 30,
                gravity: 0.05,
                // ignore: prefer_const_literals_to_create_immutables
                colors: <Color>[
                  CustomColours.lightPurple,
                  CustomColours.darkPurple,
                  CustomColours.teal,
                  Colors.white,
                ],
              ),
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
                                    Category.selectedcategory.codePoint);

                                setState(() {
                                  _isSuccess = true;
                                });

                                _confettiController.play();
                                Future<dynamic>.delayed(
                                    const Duration(seconds: 3), () {
                                  Navigator.of(this.context).pop();
                                });
                              }
                            }),
                  )
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
                    Radius.circular(Constants.avatarRadius)),
                child: Image.asset('assets/lv_logo_transparent.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// TODO: Let user select an Icon as a "category" which we can use to organise and filter ViewVictoriesScreen with.

class VictoryCategory extends StatefulWidget {
  const VictoryCategory({Key? key}) : super(key: key);

  @override
  _VictoryCategoryState createState() => _VictoryCategoryState();
}

class _VictoryCategoryState extends State<VictoryCategory> {
  late int _categoryNumber;

  static const Color _activeColor = Colors.black;
  static const Color _disabledColor = Colors.white;

  Widget _iconButton(int buttonNum, IconData categoryIcon) {
    return IconButton(
      onPressed: () {
        if (_categoryNumber != buttonNum) {
          setState(() {
            _categoryNumber = buttonNum;
          });
          Category.pressedCategory(categoryNumber: _categoryNumber);
        }
      },
      icon: Icon(categoryIcon),
      color: _categoryNumber == buttonNum ? _activeColor : _disabledColor,
    );
  }

  @override
  void initState() {
    _categoryNumber = 6;
    super.initState();
  }

  static const List<IconData> _categoryIcons = Category.categoryIcons;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemExtent: 60,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) =>
            _iconButton(index, _categoryIcons[index]),
        itemCount: 7);
  }
}

class Category {
  static const List<IconData> categoryIcons = <IconData>[
    Icons.sentiment_very_satisfied,
    Icons.local_activity,
    Icons.nature_people,
    Icons.restaurant,
    Icons.bathtub,
    Icons.fitness_center,
    Icons.help_outline,
  ];

  static IconData selectedcategory = Icons.help_outline;

  static void pressedCategory({int categoryNumber = 6}) {
    Category.selectedcategory = categoryIcons[categoryNumber];
  }

  int get categorySelected {
    // ignore: avoid_print
    print('selectedCategory: $selectedcategory');
    final int iconCodePoint = selectedcategory.codePoint;
    return iconCodePoint;
  }
}
