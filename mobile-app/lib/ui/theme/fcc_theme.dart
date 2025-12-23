import 'package:flutter/material.dart';

// Based on https://github.com/freeCodeCamp/ui/blob/01048178d606f404256c8f02299f6323c25e6a73/src/colors.css#L1-L50
class FccColors {
  static const gray00 = Color(0xFFFFFFFF);
  static const gray05 = Color(0xFFF5F6F7);
  static const gray10 = Color(0xFFDFDFE2);
  static const gray15 = Color(0xFFD0D0D5);
  static const gray45 = Color(0xFF858591);
  static const gray75 = Color(0xFF3B3B4F);
  static const gray80 = Color(0xFF2A2A40);
  static const gray85 = Color(0xFF1B1B32);
  static const gray90 = Color(0xFF0A0A23);

  static const purple10 = Color(0xFFDBB8FF);
  static const purple50 = Color(0xFF9400D3);
  static const purple90 = Color(0xFF5A01A7);

  static const yellow05 = Color(0xFFFCF8E3);
  static const yellow10 = Color(0xFFFAEBCC);
  static const yellow40 = Color(0xFFFFC300);
  static const yellow45 = Color(0xFFFFBF00);
  static const yellow50 = Color(0xFFF1BE32);
  static const yellow70 = Color(0xFF8A6D3B);
  static const yellow80 = Color(0xFF66512C);
  static const yellow90 = Color(0xFF4D3800);

  static const blue05 = Color(0xFFD9EDF7);
  static const blue10 = Color(0xFFBCE8F1);
  static const blue30 = Color(0xFF99C9FF);
  static const blue50 = Color(0xFF198EEE);
  static const blue70 = Color(0xFF31708F);
  static const blue90 = Color(0xFF002EAD);
  static const blue30Translucent = Color.fromRGBO(153, 201, 255, 0.3);
  static const blue90Translucent = Color.fromRGBO(0, 46, 173, 0.3);

  static const green05 = Color(0xFFDFF0D8);
  static const green10 = Color(0xFFD6E9C6);
  static const green40 = Color(0xFFACD157);
  static const green70 = Color(0xFF3C763D);
  static const green80 = Color(0xFF19562A);
  static const green90 = Color(0xFF00471B);

  static const red05 = Color(0xFFF2DEDE);
  static const red10 = Color(0xFFEBCCD1);
  static const red15 = Color(0xFFFFADAD);
  static const red30 = Color(0xFFF8577C);
  static const red70 = Color(0xFFA94442);
  static const red80 = Color(0xFFF82153);
  static const red90 = Color(0xFF850000);
  static const red100 = Color(0xFF5A3535);

  static const orange30 = Color(0xFFEDA971);
}

// Based on https://github.com/freeCodeCamp/ui/blob/01048178d606f404256c8f02299f6323c25e6a73/src/colors.css#L120-L140
class FccSemanticColors {
  static const foregroundPrimary = FccColors.gray00;
  static const foregroundSecondary = FccColors.gray05;
  static const foregroundTertiary = FccColors.gray10;
  static const foregroundQuaternary = FccColors.gray15;
  static const foregroundDanger = FccColors.red90;
  static const foregroundSuccess = FccColors.green90;
  static const foregroundInfo = FccColors.blue90;
  static const foregroundWarning = FccColors.yellow40;
  static const foregroundCta = FccColors.gray90;

  static const backgroundPrimary = FccColors.gray90;
  static const backgroundSecondary = FccColors.gray85;
  static const backgroundTertiary = FccColors.gray80;
  static const backgroundQuaternary = FccColors.gray75;
  static const backgroundDanger = FccColors.red15;
  static const backgroundSuccess = FccColors.green40;
  static const backgroundInfo = FccColors.blue30;
  static const backgroundSelection = FccColors.blue30Translucent;
  static const backgroundCta = FccColors.yellow40;
}

class FccTheme {
  static ThemeData themeDark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Lato',
    scaffoldBackgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
    appBarTheme: const AppBarThemeData(
      centerTitle: true,
      backgroundColor: Color(0xFF0a0a23),
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
