import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations.dart';
import 'package:little_victories/res/custom_colours.dart';

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
  Stack contentBox(context) {
    assert(context != null);
    return Stack(children: <Widget>[
      Container(
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
              colors: [
                CustomColours.lightPurple,
                CustomColours.teal,
              ],
            ),
            borderRadius: BorderRadius.circular(Constants.padding),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(offset: Offset(0, 10), blurRadius: 10),
            ]),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Constants.avatarRadius)),
                child: Image.asset("assets/lv_logo_transparent.png")),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _victoryController,
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: true,
                  maxLength: 100,
                  decoration: InputDecoration(
                    labelText: "What was your Victory?",
                    labelStyle:
                        const TextStyle(fontSize: 22.0, color: Colors.white),
                    fillColor: Colors.greenAccent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          const BorderSide(color: Colors.redAccent, width: 2),
                    ),
                    // fillColor: Colors.green
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
          const SizedBox(height: 100, child: VictoryCategory()),
          ConfettiWidget(
            blastDirectionality: BlastDirectionality.explosive,
            confettiController: _confettiController,
            emissionFrequency: 0,
            numberOfParticles: 30,
            gravity: 0.05,
            // ignore: prefer_const_literals_to_create_immutables
            colors: [
              CustomColours.lightPurple,
              CustomColours.darkPurple,
              CustomColours.teal,
              Colors.white,
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(this.context).pop();
                },
                child: const Text('Close',
                    style: TextStyle(fontSize: 15, color: Colors.white)),
              ),
              const Spacer(),
              Container(
                child: _isSuccess
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await saveLittleVictory(
                                _user,
                                _victoryController.text,
                                Category().categorySelected);

                            setState(() {
                              _isSuccess = true;
                            });

                            _confettiController.play();
                            Future.delayed(const Duration(seconds: 3), () {
                              Navigator.of(this.context).pop();
                            });
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: <Widget>[
                            const Text(
                              'Celebrate a Victory',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(Icons.celebration,
                                size: 20, color: Colors.white)
                          ],
                        ),
                      ),
              )
            ],
          ),
        ]),
      )
    ]);
  }
}

// TODO: Let user select an Icon as a "category" which we can use to organise and filter ViewVictoriesScreen with.

class Category {
  static const List<IconData> categoryIcons = [
    Icons.sentiment_very_satisfied,
    Icons.local_activity,
    Icons.nature_people,
    Icons.restaurant,
    Icons.bathtub,
    Icons.fitness_center,
    Icons.help_outline,
  ];

  static IconData selectedcategory = Icons.help_outline;

  int get categorySelected {
    // ignore: avoid_print
    print('selectedCategory: $selectedcategory');
    final iconCodePoint = selectedcategory.codePoint;
    return iconCodePoint;
  }

  static void pressedCategory({int categoryNumber = 6}) {
    Category.selectedcategory = categoryIcons[categoryNumber];
  }
}

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
        itemBuilder: (context, index) =>
            _iconButton(index, _categoryIcons[index]),
        itemCount: 7);
  }
}
