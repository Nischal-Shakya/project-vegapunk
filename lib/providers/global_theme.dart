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
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: customBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: customBlue,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontSize: 22,
        color: customBlue,
      ),
      bodyMedium: TextStyle(
        color: customBlue,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      labelSmall: TextStyle(
        fontSize: 14,
        color: Colors.white54,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
  final darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    // brightness: Brightness.dark,
    // scaffoldBackgroundColor: Colors.black,
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //     selectedItemColor: Colors.white,
    //     unselectedItemColor: Colors.white.withOpacity(0.5)),
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
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: customBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: customBlue,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontSize: 22,
        color: customBlue,
      ),
      bodyMedium: TextStyle(
        color: customBlue,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      labelSmall: TextStyle(
        fontSize: 14,
        color: Colors.white54,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
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
ColorScheme darkColorScheme = const ColorScheme(
  primary: Colors.black,
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
  brightness: Brightness.dark,
);
