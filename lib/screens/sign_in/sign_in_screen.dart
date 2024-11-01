import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:little_victories/screens/sign_in/widgets/sign_in_widget.dart';
import 'package:little_victories/util/custom_colours.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CustomColours.darkBlue,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: FadeIn(
        duration: Duration(seconds: 2),
        child: SignInWidget(),
      ),
    );
  }
}
