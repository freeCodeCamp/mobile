import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Decorative falling confetti that respects reduced-motion preferences.
class CelebrationConfetti extends StatefulWidget {
  const CelebrationConfetti({super.key, this.active = true});

  final bool active;

  @override
  State<CelebrationConfetti> createState() => _CelebrationConfettiState();
}

class _CelebrationConfettiState extends State<CelebrationConfetti>
    with SingleTickerProviderStateMixin {
  final _confetti = _ConfettiStream();
  late final _ticker = createTicker(_confetti.advance);
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
  void didUpdateWidget(CelebrationConfetti oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) _updateCelebration();
  }

  void _updateCelebration() {
    if (widget.active && _reducedMotion == false) {
      _confetti.reset();
      _ticker.start();
    } else {
      _ticker.stop();
      _confetti.reset();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.active && _reducedMotion == false
      ? IgnorePointer(
          child: ExcludeSemantics(
            child: RepaintBoundary(
              child: CustomPaint(painter: _ConfettiPainter(_confetti)),
            ),
          ),
        )
      : const SizedBox.expand();
}

class _ConfettiParticle {
  const _ConfettiParticle({
    required this.x,
    required this.born,
    required this.duration,
    required this.side,
    required this.rotation,
    required this.spin,
    required this.drift,
    required this.phase,
    required this.color,
    required this.round,
  });
  final double x;
  final double born;
  final double duration;
  final double side;
  final double rotation;
  final double spin;
  final double drift;
  final double phase;
  final Color color;
  final bool round;
}

class _ConfettiStream extends ChangeNotifier {
  static const _emissionInterval = .18;
  static const _maximumLifetime = 4.4;
  final particles = <_ConfettiParticle>[];
  double elapsed = 0;
  int _nextParticle = 0;

  void reset() {
    elapsed = 0;
    _nextParticle = 0;
    particles.clear();
    notifyListeners();
  }

  void advance(Duration time) {
    elapsed = time.inMicroseconds / Duration.microsecondsPerSecond;
    particles.removeWhere(
      (particle) => elapsed >= particle.born + particle.duration,
    );
    // TickerMode can pause painting for a long time. Only create particles that
    // could still be visible when the result card returns to the foreground.
    _nextParticle = math.max(
      _nextParticle,
      ((elapsed - _maximumLifetime) / _emissionInterval).floor(),
    );
    final lastParticle = (elapsed / _emissionInterval).floor();
    while (_nextParticle <= lastParticle) {
      particles.add(_makeParticle(_nextParticle++));
    }
    notifyListeners();
  }

  static _ConfettiParticle _makeParticle(int index) {
    // Each emission has a fresh trajectory. There is no shared animation cycle
    // that sends all the pieces back to their starting positions together.
    final random = math.Random(36 + index * 7919);
    const colors = [
      Color(0xFFFFC83D),
      Color(0xFFA99BFF),
      Color(0xFF8EC5FF),
      Color(0xFFD6245A),
    ];
    // Leave the central text relatively clear, while alternating sides.
    final x = index.isEven
        ? .05 + random.nextDouble() * .25
        : .7 + random.nextDouble() * .25;
    return _ConfettiParticle(
      x: x,
      born: index * _emissionInterval + random.nextDouble() * .12,
      duration: 2.8 + random.nextDouble() * 1.4,
      side: 4 + random.nextDouble() * 3,
      rotation: random.nextDouble() * math.pi,
      spin: (random.nextDouble() * 2 - 1) * math.pi * 1.5,
      drift: .01 + random.nextDouble() * .025,
      phase: random.nextDouble() * math.pi * 2,
      color: colors[index % colors.length],
      round: random.nextDouble() < .2,
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.stream) : super(repaint: stream);
  final _ConfettiStream stream;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final particle in stream.particles) {
      final progress = (stream.elapsed - particle.born) / particle.duration;
      if (progress <= 0 || progress >= 1) {
        continue;
      }
      final fadeIn = (progress / .08).clamp(0.0, 1.0);
      final fadeOut = ((1 - progress) / .24).clamp(0.0, 1.0);
      paint.color = particle.color.withValues(alpha: fadeIn * fadeOut * .9);
      final x =
          (particle.x +
              math.sin(progress * math.pi * 2 + particle.phase) *
                  particle.drift) *
          size.width;
      final y = -10 + progress * (size.height + 20);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + progress * particle.spin);
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
      oldDelegate.stream != stream;
}
