import 'dart:developer';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:little_victories/data/firestore_operations/firestore_victories.dart';
import 'package:little_victories/data/icon_list.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_loading_button/progress_loading_button.dart';

class QuickVictory extends StatefulWidget {
  const QuickVictory({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  State<QuickVictory> createState() => _QuickVictoryState();
}

class _QuickVictoryState extends State<QuickVictory> {
  final TextEditingController _quickVictoryTextController =
      TextEditingController();

  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 6),
  );
  final FocusNode _focusNode = FocusNode();

  int _selectedIndex = 0;
  String _selectedIconName = 'Happy';
  bool _isSaved = false;

  Future<bool> submitQuickVictory() async {
    bool _isSuccess = false;
    log('submitQuickVictory: validating form');
    if (widget.formKey.currentState!.validate()) {
      log('submitQuickVictory: form validated');
      try {
        log('submitQuickVictory: saving victory');
        _isSuccess = await saveLittleVictory(
          _quickVictoryTextController.text,
          _selectedIconName,
        );

        setState(() {
          _isSaved = _isSuccess;
        });

        if (_isSuccess) {
          log('play confetti');
          _confettiController.play();
          _quickVictoryTextController.clear();
          _focusNode.unfocus();
          widget.formKey.currentState!.reset();

          Future<void>.delayed(const Duration(seconds: 4), () {
            setState(() {
              _isSaved = false;
            });
          });
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        setState(() {
          _isSaved = false;
        });
      }
    } else {
      log('submitQuickVictory: form not validated');
      setState(() {
        _isSaved = false;
      });
    }
    return _isSuccess;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            CustomColours.darkBlue,
            CustomColours.darkBlue.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: _isSaved
          ? _quickVictoryConfetti
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _iconRow,
                _quickVictoryTextBox,
                _quickVictoryButton,
              ],
            ),
    );
  }

  Widget get _iconRow {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.06,
      child: Center(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 16);
          },
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          itemCount: victoryIconList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                setState(() {
                  if (_selectedIndex != index) {
                    _selectedIndex = index;
                    _selectedIconName = victoryIconList[index].iconName;
                    log('_selectedIconName: $_selectedIconName');
                  }
                });
              },
              child: Icon(
                victoryIconList[index].icon,
                size: _selectedIndex == index
                    ? kiconRowActiveSize
                    : kIconRowInactiveSize,
                color: _selectedIndex == index
                    ? kIconRowActiveColour
                    : kIconRowInactiveColour,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget get _quickVictoryTextBox {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
      ),
      child: Form(
        key: widget.formKey,
        child: TextFormField(
          controller: _quickVictoryTextController,
          focusNode: _focusNode,
          cursorColor: CustomColours.darkBlue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          spellCheckConfiguration: const SpellCheckConfiguration(),
          autofocus: false,
          maxLength: 100,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: kFormInputDecoration.copyWith(
            prefixIcon: Icon(
              victoryIconList[_selectedIndex].icon,
              color: CustomColours.darkBlue,
            ),
            labelText: "What's your little victory?",
            counterStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
          onTap: () => _focusNode.requestFocus(),
          onTapOutside: (PointerDownEvent event) => _focusNode.unfocus(),
          style: const TextStyle(
            fontSize: 18,
            color: CustomColours.darkBlue,
          ),
          validator: (String? value) {
            if (value!.isEmpty) {
              return 'Please enter something';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget get _quickVictoryButton {
    return LoadingButton(
      color: CustomColours.darkBlue,
      borderRadius: kButtonBorderRadius,
      defaultWidget: const Text(
        'Celebrate',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          letterSpacing: 5,
        ),
      ),
      loadingWidget: const CircularProgressIndicator(
        color: Colors.white,
      ),
      width: double.maxFinite,
      height: 50,
      onPressed: () async {
        await submitQuickVictory();
      },
    );
  }

  Widget get _quickVictoryConfetti {
    return Column(
      children: <Widget>[
        Lottie.asset(
          'assets/lottie-check.json',
          height: MediaQuery.of(context).size.height * .2,
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
    );
  }
}
