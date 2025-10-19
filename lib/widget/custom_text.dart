// lib/widgets/custom_text.dart
import 'package:flutter/material.dart';

class CustomText {
  // ✅ Ajoute "static" et rends le style optionnel (peut être null)
  static Widget center(String inputText, TextStyle? inputTheme) {
    return Text(inputText, textAlign: TextAlign.center, style: inputTheme);
  }

  static Widget left(String inputText, TextStyle? inputTheme) {
    return Text(inputText, textAlign: TextAlign.left, style: inputTheme);
  }

  static Widget right(String inputText, TextStyle? inputTheme) {
    return Text(inputText, textAlign: TextAlign.right, style: inputTheme);
  }
}
