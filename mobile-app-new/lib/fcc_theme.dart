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

/// Colors from the Sunny Day / Starry Night design palette.
@immutable
class FccDesignColors extends ThemeExtension<FccDesignColors> {
  const FccDesignColors({
    required this.success,
    required this.hint,
    required this.accentText,
    required this.hero,
    required this.donate,
    required this.onDonate,
  });

  final Color success;
  final Color hint;
  final Color accentText;
  final Color hero;
  final Color donate;
  final Color onDonate;

  static FccDesignColors of(BuildContext context) =>
      Theme.of(context).extension<FccDesignColors>()!;

  @override
  FccDesignColors copyWith({
    Color? success,
    Color? hint,
    Color? accentText,
    Color? hero,
    Color? donate,
    Color? onDonate,
  }) => FccDesignColors(
    success: success ?? this.success,
    hint: hint ?? this.hint,
    accentText: accentText ?? this.accentText,
    hero: hero ?? this.hero,
    donate: donate ?? this.donate,
    onDonate: onDonate ?? this.onDonate,
  );

  @override
  FccDesignColors lerp(covariant FccDesignColors? other, double t) {
    if (other == null) return this;
    return FccDesignColors(
      success: Color.lerp(success, other.success, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      hero: Color.lerp(hero, other.hero, t)!,
      donate: Color.lerp(donate, other.donate, t)!,
      onDonate: Color.lerp(onDonate, other.onDonate, t)!,
    );
  }
}

class FccTheme {
  static final ThemeData themeLight = _build(Brightness.light);
  static final ThemeData themeDark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final background = Color(dark ? 0xFF1A1530 : 0xFFFFF8EC);
    final surface = Color(dark ? 0xFF2B2140 : 0xFFFFFFFF);
    final raised = Color(dark ? 0xFF3F3557 : 0xFFFFF1D6);
    final line = Color(dark ? 0xFF4C4066 : 0xFFF1E2C8);
    final controlEdge = Color(dark ? 0xFF7D709D : 0xFF9D9280);
    final foreground = Color(dark ? 0xFFFFF8EC : 0xFF2B2140);
    final muted = Color(dark ? 0xFFCABEEA : 0xFF5E5470);
    final hint = Color(dark ? 0xFFCABEEA : 0xFF6F6582);
    final accent = Color(dark ? 0xFF9EA1FE : 0xFF5B4BDB);
    final accentText = Color(dark ? 0xFFBBBFFF : 0xFF5B4BDB);
    final tint = Color(dark ? 0xFF29216C : 0xFFECE8FF);
    const yellow = Color(0xFFFFC83D);
    final colors = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: dark ? const Color(0xFF1A1530) : Colors.white,
      primaryContainer: tint,
      onPrimaryContainer: foreground,
      secondary: yellow,
      onSecondary: const Color(0xFF2B2140),
      secondaryContainer: raised,
      onSecondaryContainer: foreground,
      tertiary: Color(dark ? 0xFFFFAABC : 0xFFC2185B),
      onTertiary: dark ? const Color(0xFF1A1530) : Colors.white,
      error: Color(dark ? 0xFFFFAEA2 : 0xFFD6245A),
      onError: dark ? const Color(0xFF1A1530) : Colors.white,
      surface: surface,
      onSurface: foreground,
      onSurfaceVariant: muted,
      outline: controlEdge,
      outlineVariant: line,
      surfaceContainerLowest: background,
      surfaceContainerLow: tint,
      surfaceContainer: raised,
      surfaceContainerHigh: raised,
      surfaceContainerHighest: line,
    );
    final base = ThemeData(
      brightness: brightness,
      colorScheme: colors,
      fontFamily: 'Lato',
      useMaterial3: true,
    );
    return base.copyWith(
      scaffoldBackgroundColor: background,
      canvasColor: surface,
      dividerColor: line,
      hintColor: hint,
      disabledColor: hint,
      textTheme: base.textTheme
          .copyWith(
            headlineLarge: TextStyle(
              fontSize: 32,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: foreground,
            ),
            headlineMedium: TextStyle(
              fontSize: 26,
              height: 1.25,
              fontWeight: FontWeight.w800,
              color: foreground,
            ),
            headlineSmall: TextStyle(
              fontSize: 22,
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
            titleLarge: TextStyle(
              fontSize: 20,
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
            titleMedium: TextStyle(
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
            bodyLarge: TextStyle(fontSize: 16, height: 1.6, color: foreground),
            bodyMedium: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: foreground,
            ),
            bodySmall: TextStyle(fontSize: 12, height: 1.4, color: muted),
            labelLarge: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          )
          .apply(fontFamily: 'Lato'),
      appBarTheme: AppBarThemeData(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: background,
        foregroundColor: foreground,
        titleTextStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: line),
        ),
      ),
      dividerTheme: DividerThemeData(color: line, thickness: 1, space: 1),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: tint,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: 'Lato',
            fontSize: 12,
            color: states.contains(WidgetState.selected) ? accentText : muted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? accent : muted,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: yellow,
          foregroundColor: colors.onSecondary,
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: yellow,
          foregroundColor: colors.onSecondary,
          elevation: 0,
          minimumSize: const Size(48, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: foreground,
          backgroundColor: surface,
          side: BorderSide(color: controlEdge),
          minimumSize: const Size(48, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentText,
          minimumSize: const Size(48, 48),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: muted,
          minimumSize: const Size(48, 48),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: accent,
        side: BorderSide(color: controlEdge),
        shape: const StadiumBorder(),
        labelStyle: TextStyle(fontFamily: 'Lato', color: foreground),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: raised,
        hintStyle: TextStyle(color: hint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: controlEdge),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: controlEdge),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        showDragHandle: true,
        dragHandleColor: line,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        inactiveTrackColor: line,
        thumbColor: accent,
        trackHeight: 5,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: line,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accent,
        selectionColor: accent.withValues(alpha: 0.25),
        selectionHandleColor: accent,
      ),
      extensions: [
        FccDesignColors(
          success: Color(dark ? 0xFF8DDBA3 : 0xFF1E7F46),
          hint: hint,
          accentText: accentText,
          hero: Color(dark ? 0xFF3E329C : 0xFF5B4BDB),
          donate: Color(dark ? 0xFF5B0928 : 0xFFFFE8F0),
          onDonate: Color(dark ? 0xFFFFAABC : 0xFFC2185B),
        ),
      ],
    );
  }
}
