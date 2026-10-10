import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:phone_ide/highlighting/textmate_highlighter_registry.dart';

/// A read-only article snippet using PhoneIDE's TextMate highlighting.
///
/// PhoneIDE 3's Editor hard-codes its text colors and font size. Rendering its
/// highlighted spans here lets article snippets follow the app theme and reader
/// size setting, remain selectable, and retain their natural height.
class FccCodeBlock extends StatefulWidget {
  const FccCodeBlock({
    super.key,
    required this.code,
    required this.language,
    this.fontSize = 16,
  });

  final String code;
  final String language;
  final double fontSize;

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
    final registry = TextMateHighlighterRegistry.instance;
    if (TextMateHighlighterRegistry.canonicalizeLanguage(widget.language) ==
        null) {
      return;
    }
    await registry.initialize();
    if (!mounted) return;
    setState(() {
      _highlighted = registry.buildTextSpan(
        text: widget.code,
        language: widget.language,
      );
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
    final language = switch (widget.language.trim().toLowerCase()) {
      'js' || 'javascript' => 'JavaScript',
      'htm' || 'html' => 'HTML',
      'css' => 'CSS',
      '' => 'Code',
      final name => name,
    };

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    language,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Copy code',
                  onPressed: _copy,
                  icon: const Icon(Icons.copy_rounded, size: 18),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              child: SelectableText.rich(
                palette.apply(_highlighted ?? TextSpan(text: widget.code)),
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: widget.fontSize,
                  height: 1.6,
                  color: colors.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
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
    final function = Color(dark ? 0xFF8EC5FF : 0xFF1F6FD1);
    final type = Color(dark ? 0xFFC8B0FF : 0xFF8B3FD9);
    foreground = colors.onSurface;
    tokens = {
      0xFFABB2BF: foreground,
      0xFF5C6370: colors.onSurfaceVariant,
      0xFFC678DD: colors.primary,
      0xFF98C379: design.success,
      0xFFD19A66: number,
      0xFFE5C07B: type,
      0xFF61AFEF: function,
      0xFFE06C75: colors.tertiary,
      0xFF56B6C2: colors.primary,
      0xFF5CAEEF: function,
      0xFFDFB976: number,
      0xFFC172D9: type,
      0xFF4FB1BC: colors.primary,
      0xFF97C26C: design.success,
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
