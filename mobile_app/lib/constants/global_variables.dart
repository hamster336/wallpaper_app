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
    letterSpacing: 0.2,
    fontSize: 25,
    fontWeight: FontWeight.w800,
  );

  static TextStyle headingText = TextStyle(
    color: primaryColor,
    letterSpacing: 0.2,
    fontSize: 25,
    fontWeight: FontWeight.w800,
  );

  static TextStyle infoText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
}
