import 'package:flutter/material.dart';

class FccTheme {
  static ThemeData themeDark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'RobotoMono',
    scaffoldBackgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      color: Color(0xFF0a0a23),
      scrolledUnderElevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0a0a23),
      unselectedItemColor: Color(0x99FFFFFF),
      selectedItemColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0a0a23),
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
            (states) => const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1)),
        foregroundColor:
            MaterialStateProperty.resolveWith((states) => Colors.white),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) => const Color(0x4DFFFFFF),
        ),
      ),
    ),
    canvasColor: Colors.white,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Color.fromRGBO(0xa9, 0xaa, 0xb2, 1),
      background: Color(0xFF0a0a23),
      error: Colors.red,
    ),
    primaryColorDark: const Color(0xFF0a0a23),
    primaryIconTheme: ThemeData.dark().primaryIconTheme.copyWith(
          color: Colors.orange,
        ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color.fromRGBO(66, 133, 244, 1.0),
      selectionHandleColor: Color.fromARGB(255, 255, 255, 255),
    ),
  );
}
