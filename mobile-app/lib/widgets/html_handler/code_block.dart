import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/widgets/html_handler/code_highlighter.dart';

/// A read-only article snippet using PhoneIDE and additional article grammars.
///
/// PhoneIDE 3's Editor hard-codes its text colors and font size. Rendering its
/// highlighted spans here lets article snippets follow the app theme and reader
/// size setting, remain selectable, and retain their natural height.
class FccCodeBlock extends StatefulWidget {
  const FccCodeBlock({
    super.key,
    required this.code,
    required this.language,
    this.fontSize = 13,
    this.plain = false,
    this.selectable = true,
  });

  final String code;
  final String language;
  final double fontSize;

  /// Quiz prompts use unframed code with a persistent overflow indicator.
  final bool plain;
  final bool selectable;

  @override
  State<FccCodeBlock> createState() => _FccCodeBlockState();
}

class _FccCodeBlockState extends State<FccCodeBlock> {
  final _scrollController = ScrollController();
  TextSpan? _highlighted;

  @override
  void initState() {
    super.initState();
    _highlight();
  }

  @override
  void didUpdateWidget(covariant FccCodeBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code ||
        oldWidget.language != widget.language) {
      _highlighted = null;
      _highlight();
    }
  }

  Future<void> _highlight() async {
    final code = widget.code;
    final language = widget.language;
    final highlighted = await highlightArticleCode(code, language);
    if (!mounted || widget.code != code || widget.language != language) return;
    setState(() {
      _highlighted = highlighted;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Code copied')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final palette = _CodePalette(theme);
    if (widget.plain) {
      return _code(colors, palette, padding: const EdgeInsets.only(bottom: 12));
    }
    final compact = !widget.code.contains('\n');
    final language = switch (widget.language.trim().toLowerCase()) {
      'js' || 'javascript' => 'JavaScript',
      'htm' || 'html' => 'HTML',
      'css' => 'CSS',
      'ts' || 'typescript' => 'TypeScript',
      'py' || 'py3' || 'python' || 'python3' => 'Python',
      '' => 'Code',
      final name => name,
    };

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: compact
          ? Row(
              children: [
                Expanded(
                  child: _code(
                    colors,
                    palette,
                    padding: const EdgeInsets.fromLTRB(14, 12, 0, 12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: IconButton(
                    tooltip: 'Copy code',
                    onPressed: _copy,
                    style: IconButton.styleFrom(
                      foregroundColor: colors.onSurfaceVariant,
                      minimumSize: const Size(44, 44),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.copy_outlined, size: 16),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ColoredBox(
                  color: colors.surfaceContainer,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            language,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w700,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Tooltip(
                          message: 'Copy code',
                          child: TextButton(
                            onPressed: _copy,
                            style: TextButton.styleFrom(
                              minimumSize: const Size(56, 44),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              backgroundColor: colors.surface,
                              foregroundColor: colors.onSurface,
                              textStyle: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 13,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w700,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Copy'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _code(colors, palette),
              ],
            ),
    );
  }

  Widget _code(
    ColorScheme colors,
    _CodePalette palette, {
    EdgeInsets padding = const EdgeInsets.all(12),
  }) => Scrollbar(
    controller: _scrollController,
    thumbVisibility: widget.plain ? true : null,
    trackVisibility: widget.plain ? true : null,
    child: SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: _codeText(colors, palette),
    ),
  );

  Widget _codeText(ColorScheme colors, _CodePalette palette) {
    final span = palette.apply(_highlighted ?? TextSpan(text: widget.code));
    final style = TextStyle(
      fontFamily: 'monospace',
      fontSize: widget.fontSize,
      letterSpacing: 0,
      height: 1.5,
      color: colors.onSurface,
    );
    // Answer options own taps; text selection would consume taps and swipes.
    if (!widget.selectable) {
      return Text.rich(span, textDirection: TextDirection.ltr, style: style);
    }
    return SelectableText.rich(
      span,
      textDirection: TextDirection.ltr,
      style: style,
    );
  }
}

/// PhoneIDE 3.0.0 emits a fixed Atom One Dark theme. This adapter translates its
/// token colors (and syntax_highlight 0.5's bracket colors) to Sunny Day / Starry
/// Night without replacing its grammar handling or changing shared global state.
class _CodePalette {
  _CodePalette(ThemeData theme) {
    final colors = theme.colorScheme;
    final design = theme.extension<FccDesignColors>()!;
    final dark = theme.brightness == Brightness.dark;
    final number = Color(dark ? 0xFFFFAF85 : 0xFFB93D0A);
    final type = Color(dark ? 0xFFC8B0FF : 0xFF8B3FD9);
    foreground = colors.onSurface;
    tokens = {
      0xFFABB2BF: foreground,
      0xFF5C6370: colors.onSurfaceVariant,
      0xFFC678DD: design.accentText,
      0xFF98C379: design.success,
      0xFFD19A66: number,
      0xFFE5C07B: type,
      // Syntax accents are independent of the donation palette.
      0xFF61AFEF: Color(dark ? 0xFFFF8FC0 : 0xFFC2185B),
      0xFFE06C75: foreground,
      0xFF56B6C2: foreground,
      0xFF5CAEEF: foreground,
      0xFFDFB976: foreground,
      0xFFC172D9: foreground,
      0xFF4FB1BC: foreground,
      0xFF97C26C: foreground,
      0xFFABB2C0: foreground,
      0xFFFF0000: colors.error,
    };
  }

  late final Color foreground;
  late final Map<int, Color> tokens;

  TextSpan apply(TextSpan span) {
    final color = span.style?.color;
    return TextSpan(
      text: span.text,
      style: color == null
          ? span.style
          : span.style!.copyWith(color: tokens[color.toARGB32()] ?? foreground),
      children: span.children
          ?.map((child) => child is TextSpan ? apply(child) : child)
          .toList(),
    );
  }
}
