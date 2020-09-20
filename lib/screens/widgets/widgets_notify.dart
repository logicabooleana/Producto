import 'package:flutter/material.dart';


void showSnackBar({@required BuildContext context, @required String message}) {
    SnackBar snackBar = new SnackBar(
        content: Text(message),
        action: SnackBarAction(label: 'ok', onPressed: () {}));

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }