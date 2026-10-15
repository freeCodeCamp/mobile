import 'package:flutter/material.dart';

/// Shared heading treatment for the app's top-level destinations.
class AppPageTitle extends StatelessWidget {
  const AppPageTitle(this.title, {super.key});
  final String title;

  static double toolbarHeight(BuildContext context) =>
      48 + MediaQuery.textScalerOf(context).scale(32);

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
  );
}
