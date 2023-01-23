import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_model.dart';

class ChallengeProgressBar extends StatelessWidget {
  const ChallengeProgressBar({
    Key? key,
    required this.block,
    required this.model,
  }) : super(key: key);

  final Block block;
  final BlockViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0a0a23),
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                color: const Color.fromRGBO(0x19, 0x8e, 0xee, 1),
                backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                minHeight: 10,
                value: model.challengesCompleted / block.challenges.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${(model.challengesCompleted / block.challenges.length * 100).round().toString()}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
