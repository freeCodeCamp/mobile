import 'package:flutter/material.dart';

/// Colors from the Sunny Day / Starry Night design palette.
@immutable
class FccDesignColors extends ThemeExtension<FccDesignColors> {
  const FccDesignColors({
    required this.success,
    required this.successContainer,
    required this.accentText,
    required this.hero,
  });

  final Color success;
  final Color successContainer;
  final Color accentText;
  final Color hero;

  static FccDesignColors of(BuildContext context) =>
      Theme.of(context).extension<FccDesignColors>()!;

  @override
  FccDesignColors copyWith({
    Color? success,
    Color? successContainer,
    Color? accentText,
    Color? hero,
  }) => FccDesignColors(
    success: success ?? this.success,
    successContainer: successContainer ?? this.successContainer,
    accentText: accentText ?? this.accentText,
    hero: hero ?? this.hero,
  );

  @override
  FccDesignColors lerp(covariant FccDesignColors? other, double t) {
    if (other == null) return this;
    return FccDesignColors(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      hero: Color.lerp(hero, other.hero, t)!,
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
          successContainer: Color(dark ? 0xFF003D1B : 0xFFCCFBD7),
          accentText: accentText,
          hero: Color(dark ? 0xFF3E329C : 0xFF5B4BDB),
        ),
      ],
    );
  }
}
