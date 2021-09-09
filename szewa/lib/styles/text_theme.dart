import 'package:flutter/material.dart';

abstract class TextTheme {
  static const TextStyle buttonText = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w300,
  );

  static const TextStyle infoText = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w300,
  );

  static const TextStyle joinButtonText = TextStyle(
      color: Color(0xFF00334E),
      fontSize: 14,
      fontWeight: FontWeight.w400,
  );

  static const TextStyle appLogoText = TextStyle(
      fontSize: 96,
      color: Colors.white,
      fontWeight: FontWeight.w300,
  );

  static const TextStyle loginFormText = TextStyle(
    color: Colors.white,
  );

  static const TextStyle linkUnderlineText = TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
  );

  static const TextStyle loginFormButtonText = TextStyle(
      color: Color(0xFF00334E),
  );

  static const TextStyle loginFormFieldText = TextStyle(
    color: Color(0xFFFAFFFF),
  );

}