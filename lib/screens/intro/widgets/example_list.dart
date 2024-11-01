import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/constants.dart';

class ExampleList extends StatefulWidget {
  const ExampleList({Key? key}) : super(key: key);

  @override
  State<ExampleList> createState() => _ExampleListState();
}

class _ExampleListState extends State<ExampleList>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  final ScrollController _controller = ScrollController();
  final Random _rnd = Random();
  final List<String> examples = <String>[
    'went shopping',
    'exercised',
    'made the bed',
    'washed the dishes',
    'took a walk',
    'cooked dinner',
    'paid the bills',
    'replied to friends',
    'made the phone call',
    'emptied the dishwasher',
    'had a shower',
    'sent the e-mail',
    'met up with some friends',
    'did the laundry',
    'watered the plants',
    'walked the dog',
    'applied for a job',
    'read a book',
    'played video games',
    'had a nap',
    'passed the test',
    'called the doctors',
    'ate some fruit',
    'had a bath',
  ];

  String? lastEntry;
  List<String> lastEntries = List<String>.filled(5, '0', growable: true);

  void _getEntry() {
    final String _entry = examples.elementAt(_rnd.nextInt(examples.length));
    if (_entry != lastEntry || !lastEntries.contains(_entry)) {
      setState(() {
        lastEntries.removeLast();
        lastEntries.add(_entry);
        examples.add(_entry);
      });
    } else {
      _getEntry();
    }
  }

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      // Every 2 seconds a duplicate of the examples entries is added back into the list.
      // But it checks so that it hasn't been added in the last 5 iterations.
      _getEntry();
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.transparent, Colors.white],
          stops: <double>[0.0, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        itemCount: examples.length,
        itemBuilder: (BuildContext context, int index) {
          return AutoSizeText(
            examples[index],
            style: kSubtitleStyle,
          );
        },
      ),
    );
  }
}
