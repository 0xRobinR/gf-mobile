import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorPrimary = Color(0xFF000000);
const textColor = Color(0xFF009E2C);

ThemeData primaryThemeData = ThemeData(
  primaryColor: colorPrimary,
  appBarTheme: AppBarTheme(
    backgroundColor: colorPrimary,
    titleTextStyle: GoogleFonts.spaceGrotesk(
      fontSize: 20,
      color: textColor,
    ),
  ),
  brightness: Brightness.light,
  backgroundColor: Colors.black,
  dividerColor: Colors.white54,
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
    bodySmall: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.normal, color: textColor),
    bodyMedium: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.normal, color: textColor),
    titleLarge: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
    titleSmall: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
    titleMedium: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),

  iconTheme: const IconThemeData(
    color: textColor,
    size: 24,
  ),

  buttonTheme: const ButtonThemeData(
    buttonColor: textColor,
    textTheme: ButtonTextTheme.primary,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: colorPrimary, disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: colorPrimary, disabledForegroundColor: Colors.grey.withOpacity(0.38),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: colorPrimary, disabledForegroundColor: Colors.grey.withOpacity(0.38),
    ),
  ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen).copyWith(secondary: colorPrimary),

);
