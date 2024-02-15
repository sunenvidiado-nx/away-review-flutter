import 'package:away_review/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final themeProvider = Provider((ref) {
  // TODO Add ability to switch between light and dark theme
  return _lightTheme;
});

final _lightTheme = ThemeData(
  textTheme: _textTheme,
  colorScheme: _colorScheme,
  appBarTheme: _appBarTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  inputDecorationTheme: _inputDecorationTheme,
  floatingActionButtonTheme: _floatingActionButtonTheme,
  scaffoldBackgroundColor: AppColors.background,
  useMaterial3: false,
);

ColorScheme get _colorScheme {
  return const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    background: AppColors.background,
  );
}

ElevatedButtonThemeData get _elevatedButtonTheme {
  return ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return _colorScheme.secondary.withOpacity(0.6);
          }

          return _colorScheme.primary;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return _colorScheme.primary.withOpacity(0.6);
          }

          return _colorScheme.background;
        },
      ),
      textStyle: MaterialStateProperty.all(
        GoogleFonts.rubik(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _colorScheme.background,
        ),
      ),
      padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      minimumSize: MaterialStateProperty.all(
        const Size(double.infinity, 52),
      ),
    ),
  );
}

InputDecorationTheme get _inputDecorationTheme {
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: _colorScheme.secondary.withOpacity(0.6)),
    ),
    contentPadding: const EdgeInsets.all(20),
    labelStyle: TextStyle(
      fontSize: 18,
      color: _colorScheme.secondary.withOpacity(0.6),
    ),
  );
}

TextTheme get _textTheme {
  return GoogleFonts.rubikTextTheme().apply(
    displayColor: AppColors.primary,
    bodyColor: AppColors.secondary,
  );
}

AppBarTheme get _appBarTheme {
  return AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.primary,
    elevation: 0,
    scrolledUnderElevation: 0.5,
    titleTextStyle: GoogleFonts.rubik(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    ),
  );
}

FloatingActionButtonThemeData get _floatingActionButtonTheme {
  return FloatingActionButtonThemeData(
    backgroundColor: _colorScheme.onSecondary,
    foregroundColor: _colorScheme.primary,
    extendedTextStyle: GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );
}
