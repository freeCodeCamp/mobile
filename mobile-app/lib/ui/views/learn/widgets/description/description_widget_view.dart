import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_widgets/project_demo.dart';
import 'package:freecodecamp/ui/views/learn/widgets/description/description_widget_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class DescriptionView extends StatelessWidget {
  const DescriptionView({
    super.key,
    required this.description,
    required this.instructions,
    required this.solutions,
    required this.demoType,
    required this.challengeModel,
    required this.maxChallenges,
    required this.title,
  });

  final String description;
  final String instructions;
  final List<List<SolutionFile>>? solutions;
  final DemoType? demoType;
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

        final shouldShowDemo = (solutions != null && solutions!.isNotEmpty);

        Widget demoOnClickSection() {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: RichText(
              text: TextSpan(
                style:
                    DefaultTextStyle.of(context).style.copyWith(fontSize: 20),
                children: [
                  const TextSpan(
                    text: 'Build an app that is functionally similar to ',
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ProjectDemo(
                            solutions: solutions,
                            model: challengeModel,
                          ),
                        );
                      },
                      child: const Text(
                        'this example project',
                        style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          color: FccColors.gray00,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(
                    text:
                        '. Try not to copy the example project, give it your own personal style.',
                  ),
                ],
              ),
            ),
          );
        }

        Widget demoOnLoadSection() {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: RichText(
              text: TextSpan(
                style:
                    DefaultTextStyle.of(context).style.copyWith(fontSize: 20),
                children: [
                  const TextSpan(
                    text: "Here's ",
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ProjectDemo(
                            solutions: solutions,
                            model: challengeModel,
                          ),
                        );
                      },
                      child: const Text(
                        'a preview',
                        style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          color: FccColors.gray00,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(
                    text: ' of what you will build.',
                  ),
                ],
              ),
            ),
          );
        }

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                child: Builder(
                  builder: (context) {
                    final scrollController = ScrollController();
                    return Scrollbar(
                      thumbVisibility: true,
                      trackVisibility: true,
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (demoType == DemoType.onClick && shouldShowDemo)
                              demoOnClickSection(),
                            if (demoType == DemoType.onLoad && shouldShowDemo)
                              demoOnLoadSection(),
                            ...parser.parse(description),
                            ...parser.parse(instructions),
                          ],
                        ),
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
