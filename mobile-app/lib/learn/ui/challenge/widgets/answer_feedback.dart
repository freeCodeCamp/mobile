import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';

final _bodyStyles = {
  '*': Style(fontSize: FontSize(15), lineHeight: const LineHeight(1.45)),
  'code': Style(fontSize: FontSize(13)),
  'p': Style(margin: Margins.zero),
};

class AnswerFeedback extends StatelessWidget {
  const AnswerFeedback({
    super.key,
    required this.correct,
    required this.html,
    this.fallback,
    this.outlinedInlineCode = false,
    this.margin = const EdgeInsets.only(bottom: 16),
  });

  final bool correct;
  final List<String> html;
  final String? fallback;
  final bool outlinedInlineCode;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final design = FccDesignColors.of(context);
    final background = correct
        ? design.successContainer
        : design.dangerContainer;
    final border = correct ? design.successBorder : design.dangerBorder;
    final foreground = correct
        ? design.onSuccessContainer
        : design.onDangerContainer;
    final bodies = html.where((body) => body.trim().isNotEmpty);
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (correct) ...[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: foreground,
                  ),
                  child: Icon(Icons.check, size: 16, color: background),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                correct ? 'Correct!' : 'Not quite',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: foreground,
                ),
              ),
            ],
          ),
          for (final body in bodies)
            Padding(
              padding: EdgeInsets.only(top: correct ? 8 : 4),
              child: ParsedHtml(
                body,
                outlinedInlineCode: outlinedInlineCode,
                customStyles: _bodyStyles,
              ),
            ),
          if (bodies.isEmpty && fallback != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                fallback!,
                style: const TextStyle(fontSize: 15, height: 1.45),
              ),
            ),
        ],
      ),
    );
  }
}
