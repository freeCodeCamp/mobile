import 'package:flutter/material.dart';

import 'package:freecodecamp/ui/theme/fcc_theme.dart';

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Daily Challenge',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Go Daily challenge
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width - 16,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: FccColors.yellow50, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: FccColors.yellow50,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .12),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 6,
                  width: 60,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: FccColors.gray90,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text(
                  'CHALLENGE TITLE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: FccColors.gray90,
                  ),
                ),
                Text(
                  '8-7-2025',
                  style: TextStyle(
                    color: FccColors.gray90,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Do you have the skills to complete this challenge?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: FccColors.gray90),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
