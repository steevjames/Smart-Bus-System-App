import 'package:busapp/Widgets/theme.dart';
import 'package:flutter/material.dart';

alertDialog({@required text, @required context}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          text,
          style: TextStyle(color: primaryColor, fontSize: 14),
        ),
      );
    },
  );
}

Widget snackBar(String txt) {
  return SnackBar(
    content: Text(txt, style: TextStyle(color: Colors.white)),
    backgroundColor: Colors.grey[900],
    duration: Duration(seconds: 2),
  );
}
