import 'package:flutter/material.dart';
import 'package:little_victories/widgets/common/custom_button.dart';

class HomeWidgetContainer extends StatelessWidget {
  const HomeWidgetContainer({
    Key? key,
    required this.child,
    required this.callback,
    this.backButton,
  }) : super(key: key);

  final Widget child;
  final ValueChanged<int> callback;
  final bool? backButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          child,
          const SizedBox(height: 5.0),
          CustomButton(
            'Back',
            () => callback(0),
            marginBottom: 0,
            marginTop: 0,
          ),
        ],
      ),
    );
  }
}
