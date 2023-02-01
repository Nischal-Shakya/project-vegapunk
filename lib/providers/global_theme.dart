import 'package:flutter/material.dart';

const Color customBlue = Color(0xff0a81ff);
const Color customBlueFaded = Color.fromARGB(255, 37, 143, 255);
const Color customErrorRed = Color(0xFFC5032B);
const Color customBackgroundWhite = Color(0xFFFFFBFA);
const Color customShadow = Color.fromRGBO(26, 20, 20, 10);

class GlobalTheme {
  final globalTheme = ThemeData(
    colorScheme: _customColorScheme,
    snackBarTheme: SnackBarThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: customErrorRed,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: customBackgroundWhite,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: customBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: customBackgroundWhite,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headline4: TextStyle(
        color: customBlue,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        fontSize: 22,
        color: customBlue,
      ),
      bodyText2: TextStyle(
        color: customBlue,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      subtitle1: TextStyle(
        fontSize: 12,
        color: customBlue,
      ),
      subtitle2: TextStyle(
        fontSize: 12,
        color: Colors.black26,
      ),
      caption: TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}

const ColorScheme _customColorScheme = ColorScheme(
  primary: customBlue,
  primaryContainer: customBlueFaded,
  onPrimary: customBackgroundWhite,
  secondary: Colors.amber,
  secondaryContainer: Colors.amber,
  onSecondary: Colors.amber,
  background: customBackgroundWhite,
  onBackground: Colors.black,
  surface: Colors.white70,
  onSurface: Colors.black87,
  error: customErrorRed,
  onError: Colors.white,
  shadow: Colors.black45,
  brightness: Brightness.light,
);
