import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData fuseChatDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  // Backgrounds
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),

  // Core color scheme
  colorScheme: const ColorScheme.dark(
    primary: Colors.grey,
    secondary: Color(0xFF2D5D00),
    surface: Color(0xFF1E1E1E),
    onSurface: Colors.white70,
    error: Colors.redAccent,
  ),

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
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ), // ⬆️ Taller button height
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
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF2D5D00),
    foregroundColor: Colors.white,
  ),

  // SnackBar
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.redAccent,
    contentTextStyle: TextStyle(color: Colors.white, fontSize: 14),
    behavior: SnackBarBehavior.floating,
  ),

  // Typography
  textTheme: TextTheme(
    displayLarge: GoogleFonts.irishGrover(
      fontSize: 80,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      shadows: const [
        Shadow(offset: Offset(0, 0), blurRadius: 20, color: Colors.white24),
        Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black54),
      ],
    ),
    headlineMedium: GoogleFonts.instrumentSans(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.instrumentSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white70,
    ),
    bodySmall: GoogleFonts.instrumentSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white60,
    ),
  ),

  // Icon color
  iconTheme: const IconThemeData(color: Colors.white70, size: 22),
);
