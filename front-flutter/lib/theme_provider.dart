import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color? _customPrimaryColor;

  ThemeMode get themeMode => _themeMode;
  Color? get customPrimaryColor => _customPrimaryColor;

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    final colorValue = prefs.getInt('customPrimaryColor');
    if (colorValue != null) {
      _customPrimaryColor = Color(colorValue);
    }
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', _themeMode.index);
    if (_customPrimaryColor != null) {
      prefs.setInt('customPrimaryColor', _customPrimaryColor!.value);
    }
  }

  void toggleTheme(ThemeMode mode) {
    _themeMode = mode;
    _savePreferences();
    notifyListeners();
  }

  void setCustomTheme(Color primaryColor) {
    _customPrimaryColor = primaryColor;
    _savePreferences();
    notifyListeners();
  }

  ThemeData getTheme() {
    ThemeData baseTheme =
        _themeMode == ThemeMode.dark ? ThemeData.dark() : ThemeData.light();

    if (_customPrimaryColor != null) {
      return baseTheme.copyWith(
        primaryColor: _customPrimaryColor,
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: _customPrimaryColor,
        ),
        appBarTheme: AppBarTheme(color: _customPrimaryColor),
      );
    }
    return baseTheme;
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
