import 'package:flutter/material.dart';

class Themes {
  static ThemeData greenTheme({
    final Color primary = const Color(0xff00695C),
    final Color primaryDark = const Color(0xff00897B),
    final Color primaryContrast = Colors.white,
    final Color accent = const Color(0xff80CBC4),
    final Color accentDark = const Color(0xff00695C),
    final Color accentContrast = Colors.black,
    final Color error = const Color(0xffb00020),
    final Color errorContrast = Colors.white,
    final Color background = const Color(0xFFEEEEEE),
    final Color onBackground = const Color(0xFF1E1E1E),
    final Color surface = const Color(0xFFFAFAFA),
    final Color onSurface = const Color(0xFF2A2A2A),
    final Color onPrimaryContainer = Colors.white,
  }) {
    return ThemeData.from(
      colorScheme: ColorScheme.light(
        secondaryContainer: primaryDark,
        primaryContainer: primaryDark,
        onPrimaryContainer: onPrimaryContainer,
        primary: primary,
        secondary: accent,
        onSurfaceVariant: accentDark,
        surface: surface,
        background: background,
        error: error,
        onPrimary: primaryContrast,
        onSecondary: accentContrast,
        onSurface: onSurface,
        onBackground: onBackground,
        onError: errorContrast,
        brightness: Brightness.light,
      ),
    );
  }

  static Color get blueThemeSeed => const Color.fromRGBO(9, 47, 88, 1);

  static ThemeData blueTheme() {
    return ThemeData(
        colorSchemeSeed: Themes.blueThemeSeed,
        brightness: Brightness.light,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 3, color: Colors.amber),
              borderRadius: BorderRadius.all(Radius.circular(90.0))),
          backgroundColor: Color.fromRGBO(5, 16, 79, 1),
        ),
        useMaterial3: true,
        textTheme: const TextTheme(bodyMedium: TextStyle()));
  }
}
