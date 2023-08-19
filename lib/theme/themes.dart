import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorPrimary = Color(0xFF000000);
const textColor = Color(0xFF009E2C);
const cardColor = Color(0xFF009E2C);
Color bnbColor = Colors.yellow.shade800;

ThemeData primaryThemeData = ThemeData(
  scaffoldBackgroundColor: colorPrimary,
  primaryColor: colorPrimary,
  appBarTheme: AppBarTheme(
    backgroundColor: colorPrimary,
    titleTextStyle: GoogleFonts.spaceGrotesk(
      fontSize: 20,
      color: textColor,
    ),
    iconTheme: const IconThemeData(
      color: textColor,
    ),
  ),
  dividerColor: Colors.white54,
  brightness: Brightness.dark,
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.spaceGrotesk(
        fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
    bodySmall: GoogleFonts.spaceGrotesk(
        fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
    bodyMedium: GoogleFonts.spaceGrotesk(
        fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white),
    titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
    titleSmall: GoogleFonts.spaceGrotesk(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    titleMedium: GoogleFonts.spaceGrotesk(
        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF1e2026),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black54,
  ),
);

// ------------------------------- LIGHT MODE ---------------------------------

const colorPrimaryLight = Color(0xFFFFFFFF);
const textColorLight = Color(0xFF000000);
const cardColorLight = Colors.white70;
Color bnbColorLight = Colors.yellow.shade400;

ThemeData lightModeThemeData = ThemeData(
  scaffoldBackgroundColor: colorPrimaryLight,
  primaryColor: colorPrimaryLight,
  appBarTheme: AppBarTheme(
    backgroundColor: colorPrimaryLight,
    titleTextStyle: GoogleFonts.spaceGrotesk(
      fontSize: 20,
      color: textColorLight,
    ),
    iconTheme: const IconThemeData(
      color: textColorLight,
    ),
  ),
  dividerColor: Colors.black,
  brightness: Brightness.light,
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.spaceGrotesk(
        fontSize: 20, fontWeight: FontWeight.bold, color: textColorLight),
    bodySmall: GoogleFonts.spaceGrotesk(
        fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
    bodyMedium: GoogleFonts.spaceGrotesk(
        fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),
    titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 24, fontWeight: FontWeight.bold, color: textColorLight),
    titleSmall: GoogleFonts.spaceGrotesk(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    titleMedium: GoogleFonts.spaceGrotesk(
        fontSize: 22, fontWeight: FontWeight.bold, color: textColorLight),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  iconTheme: const IconThemeData(
    color: textColorLight,
    size: 24,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
  ),
);
