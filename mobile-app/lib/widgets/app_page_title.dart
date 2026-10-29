import 'package:flutter/material.dart';

class AppPageTitle extends StatelessWidget {
  const AppPageTitle(this.title, {super.key});
  final String title;

  static double toolbarHeight(BuildContext context) =>
      48 + MediaQuery.textScalerOf(context).scale(30);

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: const TextStyle(
      fontSize: 30,
      height: 1.2,
      fontWeight: FontWeight.w900,
    ),
  );
}
