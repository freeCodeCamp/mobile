import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/dynamic_panel/panels/description/description_widget_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class DescriptionView extends StatelessWidget {
  const DescriptionView({
    Key? key,
    required this.description,
    required this.instructions,
    required this.challengeModel,
    required this.maxChallenges,
    required this.title,
  }) : super(key: key);

  final String description;
  final String instructions;
  final ChallengeViewModel challengeModel;
  final int maxChallenges;
  final String title;

  @override
  Widget build(BuildContext context) {
    List<String> splitTitle = title.split(' ');
    bool isMultiStepChallenge = splitTitle.length == 2 &&
        splitTitle[0] == 'Step' &&
        int.tryParse(splitTitle[1]) != null;
    return ViewModelBuilder<DescriptionModel>.reactive(
      viewModelBuilder: () => DescriptionModel(),
      builder: (context, model, child) {
        HTMLParser parser = HTMLParser(context: context);

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: instructions.isNotEmpty || description.isNotEmpty
                ? [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t.instructions,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isMultiStepChallenge)
                                Text(
                                  context.t.step_count(
                                    splitTitle[1],
                                    maxChallenges.toString(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: parser.parse(
                                  description,
                                ) +
                                parser.parse(instructions),
                          ),
                        ),
                      ),
                    ),
                  ]
                : [],
          ),
        );
      },
    );
  }
}
