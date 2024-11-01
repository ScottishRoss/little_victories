import 'package:flutter/material.dart';
import 'package:little_victories/widgets/common/custom_button.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final ValueChanged<int> callback;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      'Back',
      () => callback(0),
      marginBottom: 0,
      marginTop: 0,
    );
  }
}
