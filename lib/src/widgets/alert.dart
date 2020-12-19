import 'package:flutter/material.dart';

abstract class AppAlerts {
  static Future<void> showAlertDialog(BuildContext context, String message,
      {bool isSuccess = false}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'alert',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    message,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Okay",
                ),
              )
            ],
          );
        });
  }
}
