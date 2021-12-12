import 'package:flutter/material.dart';

class FccTheme {
  static ThemeData themeDark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Roboto',
    backgroundColor: const Color(0xFF0a0a23),
    appBarTheme: const AppBarTheme(centerTitle: true, color: Color(0xFF0a0a23)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0a0a23),
      unselectedItemColor: Colors.white,
      selectedItemColor: Color.fromRGBO(0x99, 0xc9, 0xff, 1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xFF0a0a23), onPrimary: Colors.white)),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => const Color(0xFF0a0a23)),
            foregroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.white))),
    canvasColor: Colors.white,
    colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: Color.fromRGBO(0xa9, 0xaa, 0xb2, 1),
        surface: Colors.white),
    errorColor: Colors.red,
    primaryColorDark: const Color(0xFF0a0a23),
    primaryIconTheme:
        ThemeData.dark().primaryIconTheme.copyWith(color: Colors.orange),
  );
}
