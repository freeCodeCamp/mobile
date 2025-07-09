import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/daily_challenges/daily_challenges_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/daily_challenges/widgets/daily_challenge_tile.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';

class DailyChallengeBlockWidget extends StatelessWidget {
  const DailyChallengeBlockWidget({
    super.key,
    required this.challengeBlock,
    required this.isOpen,
    required this.onToggleOpen,
    required this.model,
  });

  final DailyChallengeBlock challengeBlock;
  final bool isOpen;
  final VoidCallback onToggleOpen;
  final DailyChallengesViewModel model;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: model.getCompletedChallengesForBlock(challengeBlock),
      builder: (context, snapshot) {
        final completedCount = snapshot.data ?? 0;
        final totalCount = challengeBlock.challenges.length;
        final isFullyCompleted = completedCount == totalCount;

        // Progress calculation
        double progress =
            completedCount == 0 ? 0.01 : completedCount / totalCount;

        final color = FccColors.gray00;

        HTMLParser parser = HTMLParser(context: context);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
            ),
            color: const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
          ),
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.calendar_today,
                      color: color,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        challengeBlock.monthYear,
                        style: TextStyle(
                          wordSpacing: 0,
                          letterSpacing: 0,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Progress indicator or completion status
              Row(
                children: [
                  isFullyCompleted
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.check_circle,
                                  color: color,
                                ),
                              ),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: LinearProgressIndicator(
                            minHeight: 12,
                            value: progress,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            backgroundColor:
                                const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                ],
              ),

              // Description
              ...parser.parse(
                '<p>${challengeBlock.description}</p>',
                isSelectable: false,
                customStyles: {
                  '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': Style(
                    color: FccColors.gray05,
                  ),
                  'p': Style(margin: Margins.zero),
                },
              ),

              // Show/Hide Steps button
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextButton(
                      onPressed: onToggleOpen,
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(
                            color: Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                          ),
                        ),
                      ),
                      child: Text(
                        isOpen ? 'Hide Challenges' : 'Show Challenges',
                      ),
                    ),
                  ),
                ],
              ),

              // Challenge grid
              if (isOpen)
                Container(
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    maxHeight: 300,
                  ),
                  child: Builder(
                    builder: (context) {
                      final challengeCount = challengeBlock.challenges.length;
                      final isScrollable = challengeCount > 24;

                      return ScrollShadow(
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          physics: isScrollable
                              ? const AlwaysScrollableScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 3,
                          ),
                          itemCount: challengeCount,
                          itemBuilder: (context, index) {
                            final challenge = challengeBlock.challenges[index];

                            return DailyChallengeTile(
                              challenge: challenge,
                              model: model,
                              index: index,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
