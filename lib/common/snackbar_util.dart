import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message,
    [Color? backgroundColor, int duration = 2]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
      backgroundColor: backgroundColor ?? Colors.black,
    ),
  );
}
