import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';

class ChallengeGrid extends StatelessWidget {
  const ChallengeGrid({
    super.key,
    required this.onSelected,
    required this.challenges,
    required this.completed,
    this.maxVisibleItems,
    this.maxHeight = 300,
  });
  final ValueChanged<ChallengeOrder> onSelected;
  final List<ChallengeOrder> challenges;
  final Set<String> completed;
  final int? maxVisibleItems;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final design = FccDesignColors.of(context);
    final next = challenges.where((c) => !completed.contains(c.id)).firstOrNull;
    final visibleCount = math.min(
      maxVisibleItems ?? challenges.length,
      challenges.length,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final digits = challenges.indexed.fold<int>(1, (longest, entry) {
          final number =
              RegExp(r'\d+').firstMatch(entry.$2.title)?.group(0) ??
              '${entry.$1 + 1}';
          return math.max(longest, number.length);
        });
        final numeral = TextPainter(
          text: TextSpan(
            text: '8' * digits,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          textScaler: MediaQuery.textScalerOf(context),
          textDirection: Directionality.of(context),
        )..layout();
        // Preserve a compact 48px touch target until the scaled number needs
        // more room. Scaling the entire tile made small numbers look lost.
        final minimumSide = math.max(
          48.0,
          math.max(numeral.width, numeral.height) + 16,
        );
        numeral.dispose();
        final columns = math.max(
          1,
          ((constraints.maxWidth + 6) / (minimumSide + 6)).floor(),
        );
        final side = math.min(minimumSide, constraints.maxWidth);
        return Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
              maxWidth: columns * side + (columns - 1) * 6,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.zero,
              physics:
                  (visibleCount / columns).ceil() * (side + 6) - 6 > maxHeight
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: 1,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemCount: visibleCount,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                final done = completed.contains(challenge.id);
                final active = challenge == next;
                final number =
                    RegExp(r'\d+').firstMatch(challenge.title)?.group(0) ??
                    '${index + 1}';
                return Semantics(
                  label:
                      '${challenge.title}${done
                          ? ', completed'
                          : active
                          ? ', current'
                          : ''}',
                  button: true,
                  excludeSemantics: true,
                  onTap: () => onSelected(challenge),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: done
                          ? design.successContainer
                          : colors.surface,
                      foregroundColor: done
                          ? design.onSuccessContainer
                          : colors.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: done
                            ? BorderSide(
                                color: design.onSuccessContainer,
                                width: colors.brightness == Brightness.dark
                                    ? 1.5
                                    : 1,
                              )
                            : BorderSide(
                                color: active
                                    ? colors.primary
                                    : colors.outlineVariant,
                              ),
                      ),
                    ),
                    onPressed: () => onSelected(challenge),
                    child: done
                        ? Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: design.onSuccessContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              size: 16,
                              color: colors.surface,
                            ),
                          )
                        : Text(
                            number,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
