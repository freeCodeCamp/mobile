import 'package:flutter/material.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:freecodecamp/learn/ui/widgets/resizable_panel.dart';

class DescriptionPanel extends StatelessWidget {
  const DescriptionPanel({
    super.key,
    required this.html,
    required this.availableHeight,
    required this.visible,
  });

  final String html;
  final double availableHeight;
  final bool visible;

  @override
  Widget build(BuildContext context) => ClipRect(
    child: AnimatedAlign(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: Alignment.topLeft,
      heightFactor: visible ? 1 : 0,
      child: ExcludeSemantics(
        excluding: !visible,
        child: IgnorePointer(
          ignoring: !visible,
          child: ResizablePanel(
            title: 'Description',
            summaryHtml: html,
            maxHeight: availableHeight,
            maxFraction: .65,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ParsedHtml(html, outlinedInlineCode: true),
            ),
          ),
        ),
      ),
    ),
  );
}
