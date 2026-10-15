import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: FccColors.gray85,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14, left: 8, right: 8),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
