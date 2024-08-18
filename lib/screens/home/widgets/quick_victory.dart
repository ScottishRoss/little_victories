import 'dart:developer';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:little_victories/data/firestore_operations/firestore_account.dart';
import 'package:little_victories/data/firestore_operations/firestore_victories.dart';
import 'package:little_victories/data/icon_list.dart';
import 'package:little_victories/util/ad_helper.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/widgets/common/custom_toast.dart';
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
  InterstitialAd? _interstitialAd;
  Future<bool>? _future;

  Future<bool> _loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback =
              FullScreenContentCallback<InterstitialAd>(
            onAdDismissedFullScreenContent: (InterstitialAd ad) async {
              await updateAdCounter();
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (LoadAdError err) {
          log('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
    return true;
  }

  @override
  void initState() {
    super.initState();
    _future = _loadInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

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
    log('submitQuickVictory: submitting...');
    bool _isSuccess = false;
    final int adCounter = await getAdCounter();

    if (widget.formKey.currentState!.validate()) {
      try {
        _isSuccess = await saveLittleVictory(
          _quickVictoryTextController.text,
          _selectedIconName,
        );
        log('isSuccess $_isSuccess');

        setState(() {
          _isSaved = _isSuccess;
        });

        if (_isSuccess) {
          _confettiController.play();
          if (adCounter > 2) {
            log('Adcounter is $adCounter, showing interstitial');
            _interstitialAd?.show();
          }

          _quickVictoryTextController.clear();
          _focusNode.unfocus();
          widget.formKey.currentState!.reset();
          Future<void>.delayed(const Duration(seconds: 3), () {
            setState(() {
              _isSaved = false;
            });
          });
        }
      } catch (e) {
        FToast().showToast(
          child: const CustomToast(
            message: 'Something went wrong.',
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
        setState(() {
          _isSaved = false;
        });
      }
    }

    return _isSuccess;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            log('waiting');
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
            log('active');
            return _main;
          case ConnectionState.none:
            log('none');
            return const Center(
              child: CircularProgressIndicator(),
            );

          case ConnectionState.done:
            log('done');
            return _main;

          default:
            log('default');
            return _main;
        }
      },
    );
  }

  Widget get _main {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * .30,
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            CustomColours.darkBlue,
            CustomColours.darkBlue.withOpacity(0.2),
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
      color: CustomColours.hotPink,
      borderRadius: kButtonBorderRadius,
      defaultWidget: Text(
        'Celebrate',
        style: kSubtitleStyle.copyWith(
          color: CustomColours.darkBlue,
          fontSize: 22,
        ),
      ),
      loadingWidget: const CircularProgressIndicator(
        color: CustomColours.darkBlue,
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
          height: MediaQuery.of(context).size.height * .22,
        ),
        ConfettiWidget(
          blastDirectionality: BlastDirectionality.explosive,
          confettiController: _confettiController,
          emissionFrequency: 0,
          numberOfParticles: 30,
          gravity: 0.05,
          colors: const <Color>[
            CustomColours.darkBlue,
            CustomColours.hotPink,
            Colors.white,
            CustomColours.teal,
            Colors.white,
          ],
        ),
      ],
    );
  }
}
