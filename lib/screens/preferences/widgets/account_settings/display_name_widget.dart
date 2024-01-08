import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';

class DisplayNameWidget extends StatelessWidget {
  const DisplayNameWidget({
    Key? key,
    required this.form,
    required this.textController,
    required this.focusNode,
  }) : super(key: key);

  final GlobalKey<FormState> form;
  final TextEditingController textController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const AutoSizeText(
          'Display name',
          style: kPreferencesItemStyle,
        ),
        const SizedBox(height: 5.0),
        Form(
          key: form,
          child: TextFormField(
            controller: textController,
            focusNode: focusNode,
            cursorColor: CustomColours.darkBlue,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.words,
            spellCheckConfiguration: const SpellCheckConfiguration(),
            autofocus: false,
            maxLength: 50,
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            decoration: kFormInputDecoration,
            onTap: () => focusNode.requestFocus(),
            onTapOutside: (PointerDownEvent event) => focusNode.unfocus(),
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
      ],
    );
  }
}
