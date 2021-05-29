import 'package:flutter/material.dart';

zeroHeightAppbar(BuildContext context, {Color color}) {
  // Zero height appbar is used to avoid content from status bar in a clean way
  return PreferredSize(
    preferredSize: Size.fromHeight(0.0),
    child: AppBar(
      backgroundColor: color ?? Colors.blue,
      brightness: Brightness.dark,
    ),
  );
}
