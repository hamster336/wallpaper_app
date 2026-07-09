import 'package:flutter/material.dart';

Widget customTextButton(BuildContext context, String title, VoidCallback onTap) {
  return TextButton(
    onPressed: onTap,
    child: Text(
      title,
      style: TextStyle(color: Colors.red, fontSize: 17),
    ),
  );
}
