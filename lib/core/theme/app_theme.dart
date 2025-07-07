import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: const Color(0xFF070e1a), // even darker night sky
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF070e1a),
    foregroundColor: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent, 
  ),
  primaryColorLight: Color(0xFF000A19),
  cardColor: const Color(0xFF0a1120),
  cardTheme: CardThemeData(
    color: const Color(0xFF0a1120), 
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  ),
);
