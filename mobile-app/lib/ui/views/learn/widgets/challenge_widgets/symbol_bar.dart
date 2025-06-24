import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:phone_ide/phone_ide.dart';

class SymbolBar extends StatelessWidget {
  const SymbolBar({
    super.key,
    required this.editor,
    required this.model,
  });

  final Editor editor;
  final ChallengeViewModel model;

  static const List<String> symbols = [
    'Tab',
    '<',
    '/',
    '>',
    '\\',
    '\'',
    '"',
    '=',
    '{',
    '}'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 50,
      color: const Color(0xFF1b1b32),
      child: ScrollShadow(
        size: 12,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: model.symbolBarScrollController,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: symbols.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 1,
              ),
              child: TextButton(
                onPressed: () {
                  model.insertSymbol(symbols[index], editor);
                },
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                  ),
                ),
                child: Text(symbols[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
