import 'package:flutter/material.dart';
import 'package:little_victories/data/firestore_operations/firestore_account.dart';
import 'package:little_victories/util/constants.dart';
import 'package:little_victories/util/custom_colours.dart';
import 'package:little_victories/util/utils.dart';

class CustomModal extends StatefulWidget {
  const CustomModal({
    Key? key,
    required this.title,
    required this.desc,
    required this.button,
  }) : super(key: key);

  final String title, desc;
  final Widget button;

  @override
  _CustomModalState createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kModalPadding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(kModalPadding),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[
              CustomColours.lightPurple,
              CustomColours.teal,
            ],
          ),
          borderRadius: BorderRadius.circular(kModalPadding),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: MediaQuery.of(context).size.height * 0.075,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(kModalAvatarRadius),
                  ),
                  child: Image.asset('assets/lv_logo_transparent.png'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              textScaler: const TextScaler.linear(2),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.desc,
              textAlign: TextAlign.center,
              textScaler: const TextScaler.linear(1.5),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(this.context).pop();
                  },
                  // TODO: Refactor this
                  child: buildtext(
                    'Close',
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                ValueListenableBuilder<bool>(
                  valueListenable: _isLoading,
                  builder: (BuildContext context, bool value, Widget? child) {
                    if (value) {
                      return const CircularProgressIndicator();
                    } else {
                      return widget.button;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
