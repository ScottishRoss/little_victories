import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations/firestore_account.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/widgets/common/custom_button.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const HeaderPlaceholder(),
            AutoSizeText(
              'What can we call you?',
              style: kTitleTextStyle.copyWith(
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
                decoration: kFormInputDecoration,
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
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            AutoSizeText(
              "You can change this later in the 'Preferences' screen.",
              style: kPreferencesItemStyle.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            CustomButton(
              'Submit',
              () async {
                if (_form.currentState!.validate()) {
                  try {
                    await updateDisplayName(
                      _displayNameController.text,
                      context,
                    );
                  } catch (e) {
                    log('updateDisplayName error: $e');
                  }
                }
              },
              backgroundColor: CustomColours.teal,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
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
