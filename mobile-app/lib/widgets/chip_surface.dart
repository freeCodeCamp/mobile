import 'package:flutter/material.dart';

class ChipSurface extends StatelessWidget {
  const ChipSurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Theme(
    // RawChip paints transparent ink on a canvas Material; make that canvas clear too.
    data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
    child: child,
  );
}
