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

  static const TextStyle loginFormFieldText = TextStyle(
    color: Colors.white,
  );

  static const TextStyle loginFormButtonText = TextStyle(
      color: Color(0xFF00334E),
  );

  static const TextStyle linkUnderlineText = TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  static const TextStyle registerFormFieldText = TextStyle(
    color: Colors.white,
  );

  static const TextStyle registerFormButtonText = TextStyle(
    color: Color(0xFF00334E),
  );

  static const TextStyle RegisterPageMainText = TextStyle(
    fontSize: 35,
    color: Colors.white,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle chartsTabButtonText = TextStyle(
      color : Colors.black,
  );

  static const TextStyle chartsTabStatsText = TextStyle(
  fontSize: 18,
  color: Color(0xFF969696)
  );

  static const TextStyle chartsTabStatsValText = TextStyle(
      fontSize: 18,
      color: Color(0xFF003259),
      fontWeight: FontWeight.w500
  );

  static const TextStyle statsPageSnapshotErrorText = TextStyle(
      color: Colors.red
  );

  static const TextStyle statsPageText = TextStyle(
      fontSize: 18,
      color: Color(0xFF969696)
  );

  static const TextStyle statsPageValText = TextStyle(
      fontSize: 18,
      color: Color(0xFF003259),
      fontWeight: FontWeight.w500
  );

  static const TextStyle statsPageCardTitleText = TextStyle(
      fontSize: 18,
      color: Color(0xFF003259),
      fontWeight: FontWeight.w500
  );

}