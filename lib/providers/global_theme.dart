import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    inputDecorationTheme: const InputDecorationTheme(
        errorStyle: TextStyle(color: Colors.red, fontSize: 12)),
    iconTheme: const IconThemeData(
      color: Colors.black,
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        )),
    fontFamily: GoogleFonts.poppins().fontFamily,
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
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
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
        fontWeight: FontWeight.normal,
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
    inputDecorationTheme: const InputDecorationTheme(
        errorStyle: TextStyle(color: Colors.red, fontSize: 14)),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
    }),
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    fontFamily: GoogleFonts.poppins().fontFamily,
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
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
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
        color: Colors.white54,
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
  secondary: customBlue,
  secondaryContainer: customBlue,
  onSecondary: customBlue,
  background: whiteBackground,
  onBackground: Colors.black,
  surface: Colors.white70,
  onSurface: Colors.black87,
  error: Colors.red,
  onError: Colors.white,
  shadow: Colors.black54,
  brightness: Brightness.light,
);

ColorScheme darkColorScheme = const ColorScheme(
  primary: customBlue,
  primaryContainer: customBlueFaded,
  onPrimary: Colors.white,
  secondary: customBlue,
  secondaryContainer: customBlue,
  onSecondary: customBlue,
  background: blackBackground,
  onBackground: Colors.white,
  surface: Colors.white70,
  onSurface: Colors.black87,
  error: Colors.red,
  onError: Colors.white,
  shadow: Colors.white54,
  brightness: Brightness.dark,
);
