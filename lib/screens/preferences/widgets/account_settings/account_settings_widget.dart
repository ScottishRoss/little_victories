import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations/firestore_account.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/widgets/common/custom_button.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  late Stream<User?> _data;
  final TextEditingController _displayNameController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _data = FirebaseAuth.instance.userChanges();
    _displayNameController.text =
        FirebaseAuth.instance.currentUser!.displayName!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<User?>(
            stream: _data,
            builder: (
              BuildContext context,
              AsyncSnapshot<User?> snapshot,
            ) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  return _buildAccountDetailsList(snapshot);
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  return _buildAccountDetailsList(snapshot);

                default:
                  if (snapshot.hasError) {
                    return const Center(
                      child:
                          Text('Something went wrong, please try again later.'),
                    );
                  } else {
                    return _buildAccountDetailsList(snapshot);
                  }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailsList(dynamic snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _accountDetailsColumn(
          'Email',
          snapshot.data.email ?? '',
          context,
        ),
        const SizedBox(height: 20.0),
        _displayName(
          _form,
          _displayNameController,
          _focusNode,
        ),
        CustomButton(
          'Update',
          () => updateDisplayName(
            _displayNameController.text,
            context,
          ),
          backgroundColor: CustomColours.hotPink,
          textColor: CustomColours.darkBlue,
          marginTop: 0,
          marginLeft: 0,
          marginRight: 0,
        ),
      ],
    );
  }
}

Widget _accountDetailsColumn(
  String title,
  String subtitle,
  BuildContext context,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      AutoSizeText(
        title,
        style: kPreferencesItemStyle,
      ),
      const SizedBox(height: 10.0),
      AutoSizeText(
        subtitle,
        style: kSubtitleStyle.copyWith(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

Widget _displayName(
  GlobalKey<FormState> _form,
  TextEditingController _displayNameController,
  FocusNode _focusNode,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const AutoSizeText(
        'Display name',
        style: kPreferencesItemStyle,
      ),
      const SizedBox(height: 5.0),
      Form(
        key: _form,
        child: TextFormField(
          controller: _displayNameController,
          focusNode: _focusNode,
          cursorColor: CustomColours.darkBlue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.words,
          spellCheckConfiguration: const SpellCheckConfiguration(),
          autofocus: false,
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
    ],
  );
}
