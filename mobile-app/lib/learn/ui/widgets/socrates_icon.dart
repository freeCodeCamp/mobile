import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocratesIcon extends StatelessWidget {
  const SocratesIcon({super.key, required this.color, this.size = 18});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/learn/socrates.svg',
    width: size,
    height: size,
    theme: SvgTheme(currentColor: color),
    excludeFromSemantics: true,
  );
}
