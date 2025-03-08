import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFB85042), // Terracotta Red
    onPrimary: Color(0xFFE7E8D1), // Beige Text

    secondary: Color(0xFFA7BEAE), // Muted Teal
    onSecondary: Colors.black, // Black Text

    surface: Color(0xFFA7BEAE), // Teal for cards, modals, app bars
    onSurface: Color(0xFF2D2D2D), // Dark Text

    primaryContainer: Color(0xFFE7E8D1), // Beige
    onPrimaryContainer: Color(0xFF2D2D2D), // Darker Text

    secondaryContainer: Color(0xFFE7E8D1), // Beige UI Elements
    onSecondaryContainer: Color(0xFF2D2D2D), // Dark Text

    error: Colors.redAccent,
    onError: Colors.white,
  ),

  textTheme: GoogleFonts.cairoTextTheme(), // ✅ English: Use Poppins

  scaffoldBackgroundColor: Color(0xFFE7E8D1), // Light Beige

  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFA7BEAE), // Muted Teal
    elevation: 4,
    titleTextStyle: GoogleFonts.rubik(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFFB85042),
    ),
    iconTheme: IconThemeData(color: Color(0xFFB85042)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFB85042),
      foregroundColor: Color(0xFFE7E8D1),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFA7BEAE),
    hintStyle: TextStyle(color: Color(0xFF2D2D2D)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xFFB85042)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xFFB85042), width: 2),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFC107), // Deep Red
    onPrimary: Colors.black, // Golden Yellow

    secondary: Color(0xFFB71C1C), // Warm Golden
    onSecondary: Color(0xFFFFE082), // Black Text

    surface: Color(0xFF1E1E1E), // Dark Gray
    onSurface: Colors.white, // White Text

    primaryContainer: Color(0xFF2E2E2E), // Dark Brown/Red
    onPrimaryContainer: Color(0xFFFFE082), // Golden Yellow

    secondaryContainer: Color(0xFF3E2723), // Dark Gray
    onSecondaryContainer: Colors.white, // White Text

    error: Colors.redAccent,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: Color(0xFF121212), // Rich Black

  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    elevation: 4,
    titleTextStyle: GoogleFonts.montserrat(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Color(0xFFFFE082),
    ),
    iconTheme: IconThemeData(color: Color(0xFFFFC107)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFB71C1C),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF2E2E2E),
    hintStyle: TextStyle(color: Colors.white70),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xFFFFC107)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xFFFFC107), width: 2),
    ),
  ),
  textTheme: GoogleFonts.cairoTextTheme(), // ✅ English: Use Poppins
);
