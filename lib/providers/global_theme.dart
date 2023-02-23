import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color customBlue = Color(0xff0a81ff);
const Color customBlueFaded = Color.fromARGB(255, 37, 143, 255);
const Color customShadow = Color.fromRGBO(26, 20, 20, 10);
const Color whiteBackground = Color(0xFFFAFAFA);
const Color blackBackground = Color(0xFF303030);

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
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
    }),
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    fontFamily: GoogleFonts.poppins().fontFamily,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: customBlue,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: whiteBackground,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: whiteBackground,
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
      titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 16,
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
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        color: Colors.black54,
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
      ),
    ),
  );
  final darkTheme = ThemeData(
    colorScheme: darkColorScheme,
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
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    fontFamily: GoogleFonts.poppins().fontFamily,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: customBlue,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        color: customBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      // titleLarge: TextStyle(
      //   color: customBlue,
      //   fontSize: 40,
      //   fontWeight: FontWeight.bold,
      // ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        color: customBlue,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: Colors.white54,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        color: Colors.white54,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        color: Colors.black54,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        color: Colors.white,
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
  background: whiteBackground,
  onBackground: Colors.black,
  surface: Colors.white70,
  onSurface: Colors.black87,
  error: Colors.redAccent,
  onError: Colors.white,
  shadow: Colors.black45,
  brightness: Brightness.light,
);

ColorScheme darkColorScheme = const ColorScheme(
  primary: customBlue,
  primaryContainer: customBlueFaded,
  onPrimary: Colors.white,
  secondary: Colors.amber,
  secondaryContainer: Colors.amber,
  onSecondary: Colors.amber,
  background: blackBackground,
  onBackground: Colors.white,
  surface: Colors.white70,
  onSurface: Colors.black87,
  error: Colors.redAccent,
  onError: Colors.white,
  shadow: Colors.black45,
  brightness: Brightness.dark,
);
