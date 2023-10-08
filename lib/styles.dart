import 'package:flutter/material.dart';

ButtonStyle styleButton(bool isFocused) {
  return TextButton.styleFrom(
      backgroundColor: isFocused ? Colors.white : Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      fixedSize: const Size(100, 20));
}

TextStyle styleButtonText(bool isFocused) =>
    TextStyle(color: ((isFocused) ? Colors.red : Colors.white));
