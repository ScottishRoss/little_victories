import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations/firestore_victories.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/widgets/common/custom_button.dart';
import 'package:little_victories/widgets/common/custom_toast.dart';
import 'package:little_victories/widgets/common/header_placeholder.dart';
import 'package:little_victories/widgets/common/page_body.dart';

class DisplayName extends StatefulWidget {
  const DisplayName({Key? key}) : super(key: key);

  @override
  State<DisplayName> createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  final TextEditingController _displayNameController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return PageBody(
      displayName: 'friend!',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const HeaderPlaceholder(),
            AutoSizeText(
              'What can we call you?',
              style: kTitleText.copyWith(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 20.0),
            Form(
              key: _form,
              child: TextFormField(
                controller: _displayNameController,
                focusNode: _focusNode,
                cursorColor: CustomColours.darkBlue,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textCapitalization: TextCapitalization.words,
                spellCheckConfiguration: const SpellCheckConfiguration(),
                autofocus: true,
                maxLength: 50,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white,
                  errorStyle: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    letterSpacing: 1.25,
                  ),
                  counterStyle: const TextStyle(
                    fontSize: 12.0,
                    color: CustomColours.darkBlue,
                    letterSpacing: 2.0,
                  ),
                  prefixIcon: const Icon(
                    Icons.person,
                    color: CustomColours.darkBlue,
                  ),
                  labelStyle: const TextStyle(
                    fontSize: 18.0,
                    color: CustomColours.darkBlue,
                    letterSpacing: 2.0,
                  ),
                  focusColor: CustomColours.darkBlue,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kButtonBorderRadius),
                    borderSide: const BorderSide(
                      color: CustomColours.teal,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kButtonBorderRadius),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kButtonBorderRadius),
                    borderSide: const BorderSide(
                      color: CustomColours.teal,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kButtonBorderRadius),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2,
                    ),
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
            const SizedBox(height: 20.0),
            AutoSizeText(
              "This is the name that's displayed at the top of the screen.",
              style: kPreferencesItemStyle.copyWith(
                color: CustomColours.darkBlue,
              ),
            ),
            const Spacer(),
            AutoSizeText(
              "You can change this later in the 'Preferences' screen.",
              style: kPreferencesItemStyle.copyWith(
                color: CustomColours.darkBlue,
              ),
            ),
            CustomButton(
              'Submit',
              () async {
                if (_form.currentState!.validate()) {
                  try {
                    log('updateDisplayName attempt: ${_displayNameController.text}');
                    await user!.updateDisplayName(_displayNameController.text);
                    log('updateDisplayName success: ${user!.displayName}');
                    fToast.showToast(
                      child: const CustomToast(
                        message: 'Display name updated.',
                      ),
                    );
                    Navigator.pushNamed(context, '/home');
                  } catch (e) {
                    log('updateDisplayName error: $e');
                    fToast.showToast(
                      child: const CustomToast(
                        message: 'Something weng wrong. Try again later.',
                      ),
                    );
                  }
                }
              },
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "I'll do this later",
                style: kPreferencesItemStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
