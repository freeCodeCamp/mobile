import 'package:flutter/material.dart';

@immutable
class FccDesignColors extends ThemeExtension<FccDesignColors> {
  const FccDesignColors({
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.accentText,
    required this.hero,
    required this.codeSurface,
    required this.dangerFill,
    required this.dangerPressed,
    required this.dangerOutlinePressed,
    required this.donateContainer,
    required this.heatmapLow,
    required this.heatmapMid,
    required this.heatmapHigh,
    required this.successBorder,
    required this.heroForeground,
    required this.primaryPressed,
    required this.editorHighlight,
    required this.workshop,
    required this.lab,
    required this.lecture,
    required this.quiz,
    required this.javascriptMarker,
    required this.attentionContainer,
    required this.attentionBorder,
    required this.onAttentionContainer,
    required this.infoContainer,
    required this.infoBorder,
    required this.onInfoContainer,
    required this.dangerContainer,
    required this.dangerBorder,
    required this.onDangerContainer,
  });

  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color accentText;
  final Color hero;
  final Color codeSurface;
  final Color dangerFill;
  final Color dangerPressed;
  final Color dangerOutlinePressed;
  final Color donateContainer;
  final Color heatmapLow;
  final Color heatmapMid;
  final Color heatmapHigh;
  final Color successBorder;
  final Color heroForeground;
  final Color primaryPressed;
  final Color editorHighlight;
  final Color workshop;
  final Color lab;
  final Color lecture;
  final Color quiz;
  final Color javascriptMarker;
  final Color attentionContainer;
  final Color attentionBorder;
  final Color onAttentionContainer;
  final Color infoContainer;
  final Color infoBorder;
  final Color onInfoContainer;
  final Color dangerContainer;
  final Color dangerBorder;
  final Color onDangerContainer;

  static FccDesignColors of(BuildContext context) =>
      Theme.of(context).extension<FccDesignColors>()!;

  @override
  FccDesignColors copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? accentText,
    Color? hero,
    Color? codeSurface,
    Color? dangerFill,
    Color? dangerPressed,
    Color? dangerOutlinePressed,
    Color? donateContainer,
    Color? heatmapLow,
    Color? heatmapMid,
    Color? heatmapHigh,
    Color? successBorder,
    Color? heroForeground,
    Color? primaryPressed,
    Color? editorHighlight,
    Color? workshop,
    Color? lab,
    Color? lecture,
    Color? quiz,
    Color? javascriptMarker,
    Color? attentionContainer,
    Color? attentionBorder,
    Color? onAttentionContainer,
    Color? infoContainer,
    Color? infoBorder,
    Color? onInfoContainer,
    Color? dangerContainer,
    Color? dangerBorder,
    Color? onDangerContainer,
  }) => FccDesignColors(
    success: success ?? this.success,
    successContainer: successContainer ?? this.successContainer,
    onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    accentText: accentText ?? this.accentText,
    hero: hero ?? this.hero,
    codeSurface: codeSurface ?? this.codeSurface,
    dangerFill: dangerFill ?? this.dangerFill,
    dangerPressed: dangerPressed ?? this.dangerPressed,
    dangerOutlinePressed: dangerOutlinePressed ?? this.dangerOutlinePressed,
    donateContainer: donateContainer ?? this.donateContainer,
    heatmapLow: heatmapLow ?? this.heatmapLow,
    heatmapMid: heatmapMid ?? this.heatmapMid,
    heatmapHigh: heatmapHigh ?? this.heatmapHigh,
    successBorder: successBorder ?? this.successBorder,
    heroForeground: heroForeground ?? this.heroForeground,
    primaryPressed: primaryPressed ?? this.primaryPressed,
    editorHighlight: editorHighlight ?? this.editorHighlight,
    workshop: workshop ?? this.workshop,
    lab: lab ?? this.lab,
    lecture: lecture ?? this.lecture,
    quiz: quiz ?? this.quiz,
    javascriptMarker: javascriptMarker ?? this.javascriptMarker,
    attentionContainer: attentionContainer ?? this.attentionContainer,
    attentionBorder: attentionBorder ?? this.attentionBorder,
    onAttentionContainer: onAttentionContainer ?? this.onAttentionContainer,
    infoContainer: infoContainer ?? this.infoContainer,
    infoBorder: infoBorder ?? this.infoBorder,
    onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    dangerContainer: dangerContainer ?? this.dangerContainer,
    dangerBorder: dangerBorder ?? this.dangerBorder,
    onDangerContainer: onDangerContainer ?? this.onDangerContainer,
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
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      hero: Color.lerp(hero, other.hero, t)!,
      codeSurface: Color.lerp(codeSurface, other.codeSurface, t)!,
      dangerFill: Color.lerp(dangerFill, other.dangerFill, t)!,
      dangerPressed: Color.lerp(dangerPressed, other.dangerPressed, t)!,
      dangerOutlinePressed: Color.lerp(
        dangerOutlinePressed,
        other.dangerOutlinePressed,
        t,
      )!,
      donateContainer: Color.lerp(donateContainer, other.donateContainer, t)!,
      heatmapLow: Color.lerp(heatmapLow, other.heatmapLow, t)!,
      heatmapMid: Color.lerp(heatmapMid, other.heatmapMid, t)!,
      heatmapHigh: Color.lerp(heatmapHigh, other.heatmapHigh, t)!,
      successBorder: Color.lerp(successBorder, other.successBorder, t)!,
      heroForeground: Color.lerp(heroForeground, other.heroForeground, t)!,
      primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
      editorHighlight: Color.lerp(editorHighlight, other.editorHighlight, t)!,
      workshop: Color.lerp(workshop, other.workshop, t)!,
      lab: Color.lerp(lab, other.lab, t)!,
      lecture: Color.lerp(lecture, other.lecture, t)!,
      quiz: Color.lerp(quiz, other.quiz, t)!,
      javascriptMarker: Color.lerp(
        javascriptMarker,
        other.javascriptMarker,
        t,
      )!,
      attentionContainer: Color.lerp(
        attentionContainer,
        other.attentionContainer,
        t,
      )!,
      attentionBorder: Color.lerp(attentionBorder, other.attentionBorder, t)!,
      onAttentionContainer: Color.lerp(
        onAttentionContainer,
        other.onAttentionContainer,
        t,
      )!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      infoBorder: Color.lerp(infoBorder, other.infoBorder, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
      dangerBorder: Color.lerp(dangerBorder, other.dangerBorder, t)!,
      onDangerContainer: Color.lerp(
        onDangerContainer,
        other.onDangerContainer,
        t,
      )!,
    );
  }
}

class FccTheme {
  static final ThemeData themeLight = _build(Brightness.light);
  static final ThemeData themeDark = _build(Brightness.dark);

  static WidgetStateProperty<OutlinedBorder?> focusShape(
    BuildContext context, {
    double radius = 12,
    Color? color,
  }) => WidgetStateProperty.resolveWith(
    (states) => _FocusRingBorder(
      borderRadius: BorderRadius.circular(radius),
      ring:
          states.contains(WidgetState.focused) &&
              !states.contains(WidgetState.disabled)
          ? color ?? Theme.of(context).colorScheme.onSurface
          : null,
    ),
  );

  static ButtonStyle compactOutlineStyle(BuildContext context) => _buttonStyle(
    Theme.of(context).colorScheme,
    foreground: FccDesignColors.of(context).accentText,
    pressed: Theme.of(context).colorScheme.primaryContainer,
    outlined: true,
    compact: true,
  );

  static ButtonStyle surfaceButtonStyle(
    BuildContext context, {
    Color? fill,
    Color? foreground,
    Color? pressed,
    bool compact = false,
  }) => _buttonStyle(
    Theme.of(context).colorScheme,
    foreground: foreground ?? Theme.of(context).colorScheme.onSurface,
    fill: fill ?? Theme.of(context).colorScheme.surface,
    pressed: pressed ?? Theme.of(context).colorScheme.primaryContainer,
    compact: compact,
  );

  static ButtonStyle dangerOutlineStyle(BuildContext context) => _buttonStyle(
    Theme.of(context).colorScheme,
    foreground: Theme.of(context).colorScheme.error,
    pressed: FccDesignColors.of(context).dangerOutlinePressed,
    outlined: true,
  );

  static ButtonStyle dangerStyle(BuildContext context) => _buttonStyle(
    Theme.of(context).colorScheme,
    foreground: Colors.white,
    fill: FccDesignColors.of(context).dangerFill,
    pressed: FccDesignColors.of(context).dangerPressed,
    filled: true,
  );

  static ButtonStyle _buttonStyle(
    ColorScheme colors, {
    required Color foreground,
    required Color pressed,
    Color fill = Colors.transparent,
    bool filled = false,
    bool outlined = false,
    bool compact = false,
  }) => ButtonStyle(
    minimumSize: WidgetStatePropertyAll(Size(44, compact ? 44 : 48)),
    tapTargetSize: compact ? MaterialTapTargetSize.shrinkWrap : null,
    elevation: const WidgetStatePropertyAll(0),
    animationDuration: const Duration(milliseconds: 100),
    splashFactory: NoSplash.splashFactory,
    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    foregroundColor: WidgetStateProperty.resolveWith(
      (states) =>
          states.contains(WidgetState.disabled) ? colors.outline : foreground,
    ),
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled)
          ? colors.surfaceContainer
          : states.contains(WidgetState.pressed)
          ? pressed
          : fill,
    ),
    textStyle: WidgetStateProperty.resolveWith(
      (states) => TextStyle(
        letterSpacing: 0,
        fontFamily: 'Lato',
        fontSize: compact ? 14 : 16,
        fontWeight: filled ? FontWeight.w900 : FontWeight.w700,
        decoration: states.contains(WidgetState.disabled)
            ? TextDecoration.none
            : null,
      ),
    ),
    side: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled)
          ? BorderSide.none
          : outlined
          ? BorderSide(color: foreground, width: 1.5)
          : null,
    ),
    shape: WidgetStateProperty.resolveWith(
      (states) => _FocusRingBorder(
        borderRadius: BorderRadius.circular(compact ? 10 : 12),
        ring:
            states.contains(WidgetState.focused) &&
                !states.contains(WidgetState.disabled)
            ? colors.onSurface
            : null,
      ),
    ),
  );

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
      onSecondary: Color(dark ? 0xFF1A1530 : 0xFF2B2140),
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
              letterSpacing: 0,
              fontSize: 30,
              height: 1.2,
              fontWeight: FontWeight.w900,
              color: foreground,
            ),
            headlineMedium: TextStyle(
              letterSpacing: 0,
              fontSize: 26,
              height: 1.25,
              fontWeight: FontWeight.w800,
              color: foreground,
            ),
            headlineSmall: TextStyle(
              letterSpacing: 0,
              fontSize: 22,
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
            titleLarge: TextStyle(
              letterSpacing: 0,
              fontSize: 20,
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
            titleMedium: TextStyle(
              letterSpacing: 0,
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
            bodyLarge: TextStyle(
              letterSpacing: 0,
              fontSize: 16,
              height: 1.6,
              color: foreground,
            ),
            bodyMedium: TextStyle(
              letterSpacing: 0,
              fontSize: 14,
              height: 1.45,
              color: foreground,
            ),
            bodySmall: TextStyle(
              letterSpacing: 0,
              fontSize: 13,
              height: 1.4,
              color: muted,
            ),
            labelSmall: TextStyle(
              letterSpacing: 0,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
            labelLarge: TextStyle(
              letterSpacing: 0,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: foreground,
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
          letterSpacing: 0,
          fontFamily: 'Lato',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: line),
        ),
      ),
      dividerTheme: DividerThemeData(color: line, thickness: 1, space: 1),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            letterSpacing: 0,
            fontFamily: 'Lato',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: states.contains(WidgetState.selected) ? foreground : muted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? foreground : muted,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _buttonStyle(
          colors,
          foreground: colors.onSecondary,
          fill: yellow,
          pressed: Color(dark ? 0xFFD7A401 : 0xFFD7A401),
          filled: true,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buttonStyle(
          colors,
          foreground: colors.onSecondary,
          fill: yellow,
          pressed: const Color(0xFFD7A401),
          filled: true,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buttonStyle(
          colors,
          foreground: accentText,
          pressed: tint,
          outlined: true,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _buttonStyle(colors, foreground: accentText, pressed: tint),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: _buttonStyle(
          colors,
          foreground: foreground,
          pressed: raised,
          compact: true,
        ),
      ),
      chipTheme: ChipThemeData(
        color: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? raised
              : states.contains(WidgetState.selected)
              ? tint
              : Colors.transparent,
        ),
        side: WidgetStateBorderSide.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? BorderSide.none
              : BorderSide(
                  color: states.contains(WidgetState.selected)
                      ? accentText
                      : controlEdge,
                  width: states.contains(WidgetState.selected) ? 1.5 : 1,
                ),
        ),
        shape: const StadiumBorder(),
        showCheckmark: true,
        checkmarkColor: foreground,
        labelStyle: TextStyle(
          letterSpacing: 0,
          fontFamily: 'Lato',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: WidgetStateColor.resolveWith(
            (states) =>
                states.contains(WidgetState.disabled) ? controlEdge : muted,
          ),
        ),
        secondaryLabelStyle: TextStyle(
          letterSpacing: 0,
          fontFamily: 'Lato',
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? controlEdge
                : foreground,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: _buttonStyle(colors, foreground: muted, pressed: tint).copyWith(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? controlEdge
                : states.contains(WidgetState.selected)
                ? foreground
                : muted,
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? raised
                : states.contains(WidgetState.selected)
                ? tint
                : Colors.transparent,
          ),
          textStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              letterSpacing: 0,
              fontFamily: 'Lato',
              fontSize: 15,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w900
                  : FontWeight.w700,
            ),
          ),
          side: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? BorderSide.none
                : BorderSide(
                    color: states.contains(WidgetState.selected)
                        ? accentText
                        : line,
                    width: states.contains(WidgetState.selected) ? 1.5 : 1,
                  ),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? null
              : states.contains(WidgetState.selected)
              ? accent
              : raised,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? null
              : states.contains(WidgetState.selected)
              ? accent
              : controlEdge,
        ),
        trackOutlineWidth: const WidgetStatePropertyAll(1),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? null
              : states.contains(WidgetState.selected)
              ? surface
              : muted,
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: raised,
        hintStyle: TextStyle(letterSpacing: 0, color: hint),
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
          borderSide: BorderSide(color: accent, width: 2),
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
        linearMinHeight: 6,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accent,
        selectionColor: accent.withValues(alpha: 0.25),
        selectionHandleColor: accent,
      ),
      extensions: [
        FccDesignColors(
          success: Color(dark ? 0xFF8DDBA3 : 0xFF1E7F46),
          successContainer: Color(dark ? 0xFF013B1B : 0xFFCBFBD7),
          onSuccessContainer: Color(dark ? 0xFF8DDBA3 : 0xFF02743B),
          accentText: accentText,
          hero: Color(dark ? 0xFF3E329C : 0xFF5B4BDB),
          codeSurface: Color(dark ? 0xFF0F0B1F : 0xFFFFFFFF),
          dangerFill: Color(dark ? 0xFFB02019 : 0xFFD6245A),
          dangerPressed: Color(dark ? 0xFF880B09 : 0xFFC2185B),
          dangerOutlinePressed: Color(dark ? 0xFF5F0705 : 0xFFFFE8F0),
          donateContainer: Color(dark ? 0xFF5B0928 : 0xFFFFE8F0),
          heatmapLow: dark
              ? const Color(0xFF3E329C)
              : Color.lerp(tint, accent, .3)!,
          heatmapMid: dark
              ? const Color(0xFF8381FF)
              : Color.lerp(tint, accent, .65)!,
          heatmapHigh: Color(dark ? 0xFFBBBFFF : 0xFF5B4BDB),
          successBorder: Color(dark ? 0xFF03572B : 0xFF02743B),
          heroForeground: const Color(0xFFFFF8EC),
          primaryPressed: const Color(0xFFD7A401),
          editorHighlight: Color(dark ? 0xFF29216C : 0xFFF6F6FE),
          workshop: Color(dark ? 0xFFC8B0FF : 0xFF8B3FD9),
          lab: Color(dark ? 0xFF5FD3D6 : 0xFF1E7F46),
          lecture: Color(dark ? 0xFF8EC5FF : 0xFF1F6FD1),
          quiz: Color(dark ? 0xFFFFAF85 : 0xFFB93D0A),
          javascriptMarker: Color(dark ? 0xFFFFD978 : 0xFF5D4900),
          attentionContainer: Color(dark ? 0xFF3E2D02 : 0xFFFFEBC0),
          attentionBorder: Color(dark ? 0xFF5B4403 : 0xFFFCD889),
          onAttentionContainer: Color(dark ? 0xFFFCD889 : 0xFF5B4403),
          infoContainer: Color(dark ? 0xFF042F62 : 0xFFE2EEFE),
          infoBorder: Color(dark ? 0xFF07458D : 0xFFC8DEFE),
          onInfoContainer: Color(dark ? 0xFFA1C8FE : 0xFF185EB4),
          dangerContainer: Color(dark ? 0xFF5F0705 : 0xFFFEE7E3),
          dangerBorder: Color(dark ? 0xFF880B09 : 0xFFFFCFC8),
          onDangerContainer: Color(dark ? 0xFFFFAEA2 : 0xFFB02019),
        ),
      ],
    );
  }
}

class _FocusRingBorder extends RoundedRectangleBorder {
  const _FocusRingBorder({required super.borderRadius, super.side, this.ring});
  final Color? ring;

  @override
  _FocusRingBorder copyWith({
    BorderSide? side,
    BorderRadiusGeometry? borderRadius,
  }) => _FocusRingBorder(
    side: side ?? this.side,
    borderRadius: borderRadius ?? this.borderRadius,
    ring: ring,
  );

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is _FocusRingBorder) {
      return _FocusRingBorder(
        borderRadius: BorderRadiusGeometry.lerp(
          a.borderRadius,
          borderRadius,
          t,
        )!,
        side: BorderSide.lerp(a.side, side, t),
        ring: Color.lerp(a.ring, ring, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is _FocusRingBorder) return b.lerpFrom(this, t);
    return super.lerpTo(b, t);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    super.paint(canvas, rect, textDirection: textDirection);
    if (ring != null) {
      canvas.drawRRect(
        borderRadius.resolve(textDirection).toRRect(rect).inflate(3),
        Paint()
          ..color = ring!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }
}
