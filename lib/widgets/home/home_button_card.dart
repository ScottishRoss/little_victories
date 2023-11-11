import 'package:flutter/material.dart';
import 'package:little_victories/util/constants.dart';

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
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kButtonBorderRadius),
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage('assets/$image'),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: FractionalOffset.bottomLeft,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[
                    Colors.black,
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
