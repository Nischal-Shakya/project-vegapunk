import 'package:flutter/material.dart';

const Color customBlue = Color(0xff0a81ff);
const Color customBlueFaded = Color.fromARGB(255, 37, 143, 255);
const Color customShadow = Color.fromRGBO(26, 20, 20, 10);

class GlobalTheme {
  final lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    snackBarTheme: SnackBarThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Colors.redAccent,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
    }),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: customBlue,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        color: customBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      // titleLarge: TextStyle(
      //   color: customBlue,
      //   fontSize: 40,
      //   fontWeight: FontWeight.bold,
      // ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        color: customBlue,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: Colors.black54,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        color: Colors.white54,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        color: Colors.white54,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5)),
  );
}

ColorScheme lightColorScheme = const ColorScheme(
  primary: customBlue,
  primaryContainer: customBlueFaded,
  onPrimary: Colors.white,
  secondary: Colors.amber,
  secondaryContainer: Colors.amber,
  onSecondary: Colors.amber,
  background: Colors.white,
  onBackground: Colors.black,
  surface: Colors.white70,
  onSurface: Colors.black87,
  error: Colors.redAccent,
  onError: Colors.white,
  shadow: Colors.black45,
  brightness: Brightness.light,
);
