import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';

/// The score summary and a short, decorative celebration for a passed quiz.
class QuizResultCard extends StatefulWidget {
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
  State<QuizResultCard> createState() => _QuizResultCardState();
}

class _QuizResultCardState extends State<QuizResultCard>
    with SingleTickerProviderStateMixin {
  late final _celebration = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  );
  bool? _reducedMotion;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (_reducedMotion != reducedMotion) {
      _reducedMotion = reducedMotion;
      _updateCelebration();
    }
  }

  @override
  void didUpdateWidget(QuizResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.passed != widget.passed) {
      _updateCelebration();
    }
  }

  void _updateCelebration() {
    if (widget.passed && _reducedMotion == false) {
      _celebration.forward(from: 0);
    } else {
      _celebration.stop();
      _celebration.value = 1;
    }
  }

  @override
  void dispose() {
    _celebration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final success = FccDesignColors.of(context).success;
    final accent = widget.passed ? success : colors.error;
    final tint = widget.passed
        ? Color(dark ? 0xFF143E34 : 0xFFD9F5E3)
        : colors.error.withValues(alpha: dark ? .18 : .1);
    final border = widget.passed
        ? Color(dark ? 0xFF285C52 : 0xFFB5E7C8)
        : colors.error.withValues(alpha: .35);
    final badge = widget.passed
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
            if (widget.passed && _reducedMotion == false)
              Positioned.fill(
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: _ConfettiPainter(_celebration),
                      ),
                    ),
                  ),
                ),
              ),
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
                          widget.passed ? Icons.check_rounded : Icons.refresh,
                          color: accent,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.passed ? 'You passed!' : 'Keep going!',
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
                      '${widget.correct} of ${widget.total} correct',
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
                      widget.passed
                          ? 'You needed ${widget.requiredCorrect}. Nice work.'
                          : 'You need ${widget.requiredCorrect} correct to pass. Review your answers and try again.',
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

class _ConfettiParticle {
  const _ConfettiParticle({
    required this.x,
    required this.delay,
    required this.duration,
    required this.side,
    required this.rotation,
    required this.color,
    required this.round,
  });
  final double x;
  final double delay;
  final double duration;
  final double side;
  final double rotation;
  final Color color;
  final bool round;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.animation) : super(repaint: animation);
  final Animation<double> animation;

  static final _particles = _makeParticles();
  static List<_ConfettiParticle> _makeParticles() {
    final random = math.Random(36);
    const colors = [
      Color(0xFFFFC83D),
      Color(0xFFA99BFF),
      Color(0xFF8EC5FF),
      Color(0xFFD6245A),
    ];
    return List.generate(24, (index) {
      // Leave the central text relatively clear, while alternating sides.
      final x = index.isEven
          ? .05 + random.nextDouble() * .25
          : .7 + random.nextDouble() * .25;
      return _ConfettiParticle(
        x: x,
        delay: index * .16,
        duration: 2.8 + random.nextDouble() * 1.4,
        side: 4 + random.nextDouble() * 3,
        rotation: random.nextDouble() * math.pi,
        color: colors[index % colors.length],
        round: index % 5 == 3,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final elapsed = animation.value * 8;
    final paint = Paint();
    for (final particle in _particles) {
      final progress = (elapsed - particle.delay) / particle.duration;
      if (progress <= 0 || progress >= 1) {
        continue;
      }
      final fadeIn = (progress / .08).clamp(0.0, 1.0);
      final fadeOut = ((1 - progress) / .24).clamp(0.0, 1.0);
      paint.color = particle.color.withValues(alpha: fadeIn * fadeOut * .9);
      final x =
          (particle.x + math.sin(progress * math.pi * 2) * .025) * size.width;
      final y = -10 + progress * (size.height + 20);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + progress * math.pi * 1.5);
      if (particle.round) {
        canvas.drawCircle(Offset.zero, particle.side / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.side,
              height: particle.side * .8,
            ),
            const Radius.circular(1),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.animation != animation;
}
