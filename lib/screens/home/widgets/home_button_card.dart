import 'package:flutter/material.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';

class HomeButtonCard extends StatelessWidget {
  const HomeButtonCard({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .16,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kButtonBorderRadius),
        border: Border.all(
          color: CustomColours.darkBlue,
          width: 2,
        ),
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/$image'),
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
        ),
      ),
      child: Align(
        alignment: FractionalOffset.bottomLeft,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: <double>[1, 1],
              colors: <Color>[
                CustomColours.teal,
                Colors.transparent,
              ],
            ),
          ),
          child: Text(
            title,
            style: kSubtitleStyle.copyWith(
              color: CustomColours.darkBlue,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
