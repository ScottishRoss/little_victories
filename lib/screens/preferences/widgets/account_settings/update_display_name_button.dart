import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations/firestore_account.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:progress_loading_button/progress_loading_button.dart';

class UpdateDisplayNameButton extends StatelessWidget {
  const UpdateDisplayNameButton({
    Key? key,
    required this.displayName,
    required this.context,
  }) : super(key: key);

  final String displayName;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return LoadingButton(
      color: CustomColours.hotPink,
      borderRadius: kButtonBorderRadius,
      defaultWidget: const Text(
        'Update',
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
        await updateDisplayName(
          displayName,
          context,
        );
      },
    );
  }
}
