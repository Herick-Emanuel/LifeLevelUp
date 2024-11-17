// lib/theme_provider.dart

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;
  Color primaryColor = Colors.blue;

  ThemeData getTheme() {
    return ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: generateMaterialColor(primaryColor),
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }

  void toggleTheme(bool isOn) {
    isDarkMode = isOn;
    notifyListeners();
  }

  void updatePrimaryColor(Color color) {
    primaryColor = color;
    notifyListeners();
  }

  MaterialColor generateMaterialColor(Color color) {
    Map<int, Color> colorCodes = {
      50: Color.alphaBlend(color.withOpacity(.05), Colors.white),
      100: Color.alphaBlend(color.withOpacity(.1), Colors.white),
      200: Color.alphaBlend(color.withOpacity(.2), Colors.white),
      300: Color.alphaBlend(color.withOpacity(.3), Colors.white),
      400: Color.alphaBlend(color.withOpacity(.4), Colors.white),
      500: Color.alphaBlend(color.withOpacity(.5), Colors.white),
      600: Color.alphaBlend(color.withOpacity(.6), Colors.white),
      700: Color.alphaBlend(color.withOpacity(.7), Colors.white),
      800: Color.alphaBlend(color.withOpacity(.8), Colors.white),
      900: Color.alphaBlend(color.withOpacity(.9), Colors.white),
    };
    return MaterialColor(color.value, colorCodes);
  }
}
