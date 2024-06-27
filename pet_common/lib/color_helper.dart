import 'package:flutter/material.dart';

class ColorHelper {
  static Color getTextColorBasedOnBackground(Color backgroundColor) {
    // Calculate the luminance of the background color
    double luminance = backgroundColor.computeLuminance();

    // If the luminance is high, use a dark text color, otherwise use a light text color
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  static Color hexToColor(int code) {
    return Color(code + 0xFF000000);
  }
}
