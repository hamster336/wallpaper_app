import 'package:flutter/material.dart';

class GlobalVariables {
  static Color primaryColor = const Color.fromARGB(255, 216, 20, 6);
  static Color backgroundColor = Color.fromARGB(255, 229, 70, 70);
  static Color tertiaryColor = Color.fromARGB(255, 144, 145, 245);

  static TextStyle smallText = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w300,
  );

  static TextStyle titleText = TextStyle(
    color: primaryColor,
    letterSpacing: 0.1,
    fontSize: 25,
    fontWeight: FontWeight.w700,
  );

  static TextStyle infoText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
}
