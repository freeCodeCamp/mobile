import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/ui/widgets/celebration_confetti.dart';

/// The score summary and a decorative celebration for a passed quiz.
class QuizResultCard extends StatelessWidget {
  const QuizResultCard({
    super.key,
    required this.passed,
    required this.correct,
    required this.total,
    required this.requiredCorrect,
  }) : assert(correct >= 0 && correct <= total),
       assert(requiredCorrect >= 0 && requiredCorrect <= total);

  final bool passed;
  final int correct;
  final int total;
  final int requiredCorrect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final success = FccDesignColors.of(context).success;
    final accent = passed ? success : colors.error;
    final tint = passed
        ? Color(dark ? 0xFF143E34 : 0xFFD9F5E3)
        : colors.error.withValues(alpha: dark ? .18 : .1);
    final border = passed
        ? Color(dark ? 0xFF285C52 : 0xFFB5E7C8)
        : colors.error.withValues(alpha: .35);
    final badge = passed
        ? Color(dark ? 0xFF245F4B : 0xFFB9E7CB)
        : colors.error.withValues(alpha: .16);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [tint, tint.withValues(alpha: 0)],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: CelebrationConfetti(active: passed)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExcludeSemantics(
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: badge,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          passed ? Icons.check_rounded : Icons.refresh,
                          color: accent,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      passed ? 'You passed!' : 'Keep going!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$correct of $total correct',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      passed
                          ? 'You needed $requiredCorrect. Nice work.'
                          : 'You need $requiredCorrect correct to pass. Review your answers and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
