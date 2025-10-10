import 'package:flutter/material.dart';

final ThemeData fuseChatDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212), 
  colorScheme: const ColorScheme.dark(
    primary: Colors.grey,        
    secondary: Color(0xFF2D5D00),      
    surface: Color(0xFF1E1E1E),        
    onSurface: Colors.grey,          
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  cardColor:  Color(0xFF1E1E1E),
  searchBarTheme: const SearchBarThemeData(
    backgroundColor: WidgetStatePropertyAll(Colors.white),
    textStyle:  WidgetStatePropertyAll(TextStyle(color: Colors.black)), 
    hintStyle: WidgetStatePropertyAll(
      TextStyle(color: Colors.black54),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor:Color(0xFF1E1E1E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    hintStyle: const TextStyle(color: Colors.grey),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
  ),
);
