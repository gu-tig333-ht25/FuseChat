import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const List<Color> conversationBubbleColors = [
  Color.fromARGB(255, 194, 194, 194),
  Colors.deepPurpleAccent,
  Colors.teal,
  Colors.indigo,
  Colors.cyan,
  Colors.amber,
  Colors.deepOrange,
];
const ColorScheme darkColorScheme = ColorScheme.dark(
  primary: Color(0xFF727A69),
  secondary: Color(0xFF2A2A2A),
  surface: Color(0xFF1E1E1E),
  onSurface: Color.fromARGB(61, 255, 255, 255),
  error: Colors.redAccent,
);

final ThemeData fuseChatDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  // Backgrounds
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),

  // Core color scheme
  colorScheme: darkColorScheme,

  // AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    foregroundColor: Colors.white,
    titleTextStyle: GoogleFonts.instrumentSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: Colors.white,
    ),
  ),

  // Input fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2A2A2A),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(
      color: Colors.white.withValues(alpha: 0.5),
      fontSize: 14,
    ),
    labelStyle: const TextStyle(color: Colors.white70, fontSize: 14),
  ),

  // Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3A3A3A),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white70,
      textStyle: GoogleFonts.instrumentSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white.withValues(alpha: 0.7),
      ),
    ),
  ),

  // Floating button
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: darkColorScheme.secondary,
    foregroundColor: Colors.white,
  ),

  // SnackBar
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.redAccent,
    contentTextStyle: TextStyle(color: Colors.white, fontSize: 14),
    behavior: SnackBarBehavior.floating,
  ),

  // Typography
  textTheme: ThemeData.dark().textTheme
      .apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
        decorationColor: Colors.white,
      )
      .copyWith(
        displayLarge: GoogleFonts.irishGrover(
          fontSize: 80,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          shadows: const [
            Shadow(offset: Offset(0, 0), blurRadius: 20, color: Colors.white24),
            Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black54),
          ],
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),

  dividerTheme: DividerThemeData(
    color: darkColorScheme.onSurface,
    thickness: 2,
    space: 0,
  ),
);

ColorScheme lightColorScheme = ColorScheme.light(
  primary: Color.fromARGB(166, 171, 255, 102),
  secondary: Color(0xFF73A942),
  surface: Color(0xFFFFFFFF),
  onSurface: const Color.fromARGB(255, 230, 230, 230),
  error: Colors.redAccent,
);

final ThemeData fuseChatLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  // Backgrounds
  scaffoldBackgroundColor: const Color(0xFFF7F7F7),
  cardColor: const Color(0xFFFFFFFF),

  // Core color scheme
  colorScheme: lightColorScheme,

  // AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    foregroundColor: Colors.black,
    titleTextStyle: GoogleFonts.instrumentSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: Colors.black87,
    ),
  ),

  // Input fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF0F0F0),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(
      color: Colors.black.withValues(alpha: 0.5),
      fontSize: 14,
    ),
    labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
  ),

  // Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2D5D00),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black87,
      textStyle: GoogleFonts.instrumentSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black.withValues(alpha: 0.7),
      ),
    ),
  ),

  // Floating button
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: lightColorScheme.secondary,
    foregroundColor: Colors.white,
  ),

  // SnackBar
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.redAccent,
    contentTextStyle: TextStyle(color: Colors.white, fontSize: 14),
    behavior: SnackBarBehavior.floating,
  ),

  // Typography
  textTheme: ThemeData.light().textTheme
      .apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
        decorationColor: Colors.black,
      )
      .copyWith(
        displayLarge: GoogleFonts.irishGrover(
          fontSize: 80,
          fontWeight: FontWeight.w400,
          color: Colors.black,
          shadows: const [
            Shadow(offset: Offset(0, 0), blurRadius: 10, color: Colors.black),
            Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.grey),
          ],
        ),
      ),

  dividerTheme: DividerThemeData(
    color: lightColorScheme.onSurface,
    thickness: 10,
    space: 1,
  ),
);
