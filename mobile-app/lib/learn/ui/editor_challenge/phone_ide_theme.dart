import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:phone_ide/phone_ide.dart';

EditorOptions phoneIdeOptions(
  BuildContext context, {
  EditorRegionOptions? regionOptions,
}) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;
  final design = theme.extension<FccDesignColors>()!;
  final dark = theme.brightness == Brightness.dark;
  final background = colors.surface;
  final highlight = Color(dark ? 0xFF29216C : 0xFFF6F6FE);
  return EditorOptions(
    backgroundColor: background,
    regionOptions: regionOptions == null
        ? null
        : EditorRegionOptions(
            start: regionOptions.start,
            end: regionOptions.end,
            color: highlight,
            borderColor: colors.primary,
          ),
    linebarColor: theme.scaffoldBackgroundColor,
    linebarTextColor: colors.onSurfaceVariant,
    linebarBorderColor: colors.outlineVariant,
    textColor: colors.onSurface,
    cursorColor: colors.primary,
    selectionColor: theme.textSelectionTheme.selectionColor,
    selectionHandleColor: colors.primary,
    activeLineColor: regionOptions == null ? highlight : null,
    activeLineBorderColor: regionOptions == null ? colors.primary : null,
    diagnosticColor: colors.error,
    diagnosticBackgroundColor: colors.error.withValues(alpha: 0.06),
    fontFamily: 'Hack',
    fontSize: 16,
    lineHeight: 1.5,
    linebarWidth: 28,
    // Keep syntax readable over both the plum canvas and selected regions.
    syntaxTheme: EditorSyntaxTheme(
      foreground: colors.onSurface,
      comment: dark ? const Color(0xFFC2B8DE) : colors.onSurfaceVariant,
      keyword: dark ? const Color(0xFFC8B0FF) : design.accentText,
      string: design.success,
      number: Color(dark ? 0xFFFFAF85 : 0xFFB93D0A),
      type: dark ? colors.secondary : const Color(0xFF8B3FD9),
      function: Color(dark ? 0xFF8EC5FF : 0xFF1F6FD1),
      tag: dark ? const Color(0xFF8EC5FF) : design.accentText,
      attribute: dark ? const Color(0xFFFFAF85) : colors.onSurface,
      operator: dark ? const Color(0xFFFF9ECB) : colors.onSurfaceVariant,
      punctuation: colors.onSurfaceVariant,
      variable: colors.onSurface,
    ),
  );
}
