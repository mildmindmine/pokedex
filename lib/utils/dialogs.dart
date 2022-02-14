import 'package:flutter/material.dart';

class Dialogs {
  Dialogs._();

  static void dismissDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void genericAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? positiveButtonText,
    VoidCallback? onPositiveButtonPressed,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: Text(message, textAlign: TextAlign.center),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed:
                    onPositiveButtonPressed ?? () => dismissDialog(context),
                child: Text(positiveButtonText ?? 'OK')),
          ],
        );
      },
    );
  }
}
