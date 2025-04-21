import 'package:flutter/material.dart';

// Based on https://github.com/freeCodeCamp/ui/blob/01048178d606f404256c8f02299f6323c25e6a73/src/colors.css#L1-L50
const fccColors = {
  // Gray
  'gray00': Color(0xFFFFFFFF),
  'gray05': Color(0xFFF5F6F7),
  'gray10': Color(0xFFDFDFE2),
  'gray15': Color(0xFFD0D0D5),
  'gray45': Color(0xFF858591),
  'gray75': Color(0xFF3B3B4F),
  'gray80': Color(0xFF2A2A40),
  'gray85': Color(0xFF1B1B32),
  'gray90': Color(0xFF0A0A23),

  // Purple
  'purple10': Color(0xFFDBB8FF),
  'purple50': Color(0xFF9400D3),
  'purple90': Color(0xFF5A01A7),

  // Yellow
  'yellow05': Color(0xFFFCF8E3),
  'yellow10': Color(0xFFFAEBCC),
  'yellow40': Color(0xFFFFC300),
  'yellow45': Color(0xFFFFBF00),
  'yellow50': Color(0xFFF1BE32),
  'yellow70': Color(0xFF8A6D3B),
  'yellow90': Color(0xFF4D3800),

  // Blue
  'blue05': Color(0xFFD9EDF7),
  'blue10': Color(0xFFBCE8F1),
  'blue30': Color(0xFF99C9FF),
  'blue50': Color(0xFF198EEE),
  'blue70': Color(0xFF31708F),
  'blue90': Color(0xFF002EAD),
  'blue30Translucent': Color.fromRGBO(153, 201, 255, 0.3),
  'blue90Translucent': Color.fromRGBO(0, 46, 173, 0.3),

  // Green
  'green05': Color(0xFFDFF0D8),
  'green10': Color(0xFFD6E9C6),
  'green40': Color(0xFFACD157),
  'green70': Color(0xFF3C763D),
  'green90': Color(0xFF00471B),

  // Red
  'red05': Color(0xFFF2DEDE),
  'red10': Color(0xFFEBCCD1),
  'red15': Color(0xFFFFADAD),
  'red30': Color(0xFFF8577C),
  'red70': Color(0xFFA94442),
  'red80': Color(0xFFF82153),
  'red90': Color(0xFF850000),
};

// Based on https://github.com/freeCodeCamp/ui/blob/01048178d606f404256c8f02299f6323c25e6a73/src/colors.css#L120-L140
final fccSemanticColors = {
  // Foreground
  'foregroundPrimary': fccColors['gray00'],
  'foregroundSecondary': fccColors['gray05'],
  'foregroundTertiary': fccColors['gray10'],
  'foregroundQuaternary': fccColors['gray15'],
  'foregroundDanger': fccColors['red90'],
  'foregroundSuccess': fccColors['green90'],
  'foregroundInfo': fccColors['blue90'],
  'foregroundWarning': fccColors['yellow40'],

  // Background
  'backgroundPrimary': fccColors['gray90'],
  'backgroundSecondary': fccColors['gray85'],
  'backgroundTertiary': fccColors['gray80'],
  'backgroundQuaternary': fccColors['gray75'],
  'backgroundDanger': fccColors['red15'],
  'backgroundSuccess': fccColors['green40'],
  'backgroundInfo': fccColors['blue30'],
  'backgroundSelection': fccColors['blue30Translucent'],
};

class FccTheme {
  static ThemeData themeDark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Lato',
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
        backgroundColor: WidgetStateProperty.resolveWith(
            (states) => const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1)),
        foregroundColor:
            WidgetStateProperty.resolveWith((states) => Colors.white),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => const Color(0x4DFFFFFF),
        ),
      ),
    ),
    canvasColor: Colors.white,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Color.fromRGBO(0xa9, 0xaa, 0xb2, 1),
      surface: Color(0xFF0a0a23),
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
