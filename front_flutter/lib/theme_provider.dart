import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color? _customPrimaryColor;
  Color? _customSecondaryColor;
  Color? _customBackgroundColor;
  Color? _customTextColor;

  ThemeMode get themeMode => _themeMode;
  Color? get customPrimaryColor => _customPrimaryColor;
  Color? get customSecondaryColor => _customSecondaryColor;
  Color? get customBackgroundColor => _customBackgroundColor;
  Color? get customTextColor => _customTextColor;

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];

    final primaryColorValue = prefs.getInt('customPrimaryColor');
    if (primaryColorValue != null) {
      _customPrimaryColor = Color(primaryColorValue);
    }

    final secondaryColorValue = prefs.getInt('customSecondaryColor');
    if (secondaryColorValue != null) {
      _customSecondaryColor = Color(secondaryColorValue);
    }

    final backgroundColorValue = prefs.getInt('customBackgroundColor');
    if (backgroundColorValue != null) {
      _customBackgroundColor = Color(backgroundColorValue);
    }

    final textColorValue = prefs.getInt('customTextColor');
    if (textColorValue != null) {
      _customTextColor = Color(textColorValue);
    }

    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', _themeMode.index);

    if (_customPrimaryColor != null) {
      prefs.setInt('customPrimaryColor', _customPrimaryColor!.value);
    }

    if (_customSecondaryColor != null) {
      prefs.setInt('customSecondaryColor', _customSecondaryColor!.value);
    }

    if (_customBackgroundColor != null) {
      prefs.setInt('customBackgroundColor', _customBackgroundColor!.value);
    }

    if (_customTextColor != null) {
      prefs.setInt('customTextColor', _customTextColor!.value);
    }
  }

  void toggleTheme(ThemeMode mode) {
    _themeMode = mode;
    _savePreferences();
    notifyListeners();
  }

  void setCustomTheme({
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? textColor,
  }) {
    if (primaryColor != null) _customPrimaryColor = primaryColor;
    if (secondaryColor != null) _customSecondaryColor = secondaryColor;
    if (backgroundColor != null) _customBackgroundColor = backgroundColor;
    if (textColor != null) _customTextColor = textColor;

    _savePreferences();
    notifyListeners();
  }

  void resetCustomTheme() {
    _customPrimaryColor = null;
    _customSecondaryColor = null;
    _customBackgroundColor = null;
    _customTextColor = null;
    _savePreferences();
    notifyListeners();
  }

  ThemeData getTheme() {
    ThemeData baseTheme =
        _themeMode == ThemeMode.dark ? ThemeData.dark() : ThemeData.light();

    return baseTheme.copyWith(
      primaryColor: _customPrimaryColor ?? baseTheme.primaryColor,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: _customPrimaryColor ?? baseTheme.colorScheme.primary,
        secondary: _customSecondaryColor ?? baseTheme.colorScheme.secondary,
        surface: _customBackgroundColor ?? baseTheme.colorScheme.surface,
        onSurface: _customTextColor ?? baseTheme.colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor:
            _customPrimaryColor ?? baseTheme.appBarTheme.backgroundColor,
      ),
      textTheme: baseTheme.textTheme.apply(
        bodyColor: _customTextColor ?? baseTheme.textTheme.bodyLarge?.color,
        displayColor:
            _customTextColor ?? baseTheme.textTheme.displayLarge?.color,
      ),
    );
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
