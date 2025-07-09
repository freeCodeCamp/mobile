import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/daily_challenges/daily_challenges_viewmodel.dart';

class DailyChallengeTile extends StatelessWidget {
  const DailyChallengeTile({
    super.key,
    required this.challenge,
    required this.model,
    required this.index,
  });

  final DailyChallengeItem challenge;
  final DailyChallengesViewModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: model.isChallengeCompleted(challenge.id),
      builder: (context, snapshot) {
        final isCompleted = snapshot.data ?? false;

        return TextButton(
          onPressed: () {
            model.navigateToDailyChallenge(challenge.date);
          },
          style: TextButton.styleFrom(
            backgroundColor: isCompleted
                ? const Color.fromRGBO(0x00, 0x2e, 0xad, 0.3)
                : const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: isCompleted
                  ? const BorderSide(
                      width: 1,
                      color: Color.fromRGBO(0xbc, 0xe8, 0xf1, 1),
                    )
                  : const BorderSide(
                      color: Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                    ),
            ),
          ),
          child: Text(
            (index + 1).toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
