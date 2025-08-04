import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/daily_challenge/daily_challenge_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class DailyChallengeView extends StatelessWidget {
  const DailyChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DailyChallengeViewModel>.reactive(
      viewModelBuilder: () => DailyChallengeViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: const Text('Daily Coding Challenges'),
          ),
          drawer: const DrawerWidgetView(),
          body: model.isBusy
              ? const Center(child: CircularProgressIndicator())
              : model.blocks.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: model.blocks.length,
                        itemBuilder: (context, index) {
                          final block = model.blocks[index];
                          final isOpen =
                              model.blockOpenStates[block.monthYear] ?? false;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: buildBlock(context, block, isOpen, model),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text(
                        'No challenges available at the moment.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
        );
      },
    );
  }

  Widget buildBlock(BuildContext context, DailyChallengeBlock block,
      bool isOpen, DailyChallengeViewModel model) {
    HTMLParser parser = HTMLParser(context: context);
    return FutureBuilder<int>(
      future: model.getCompletedChallengesForBlock(block),
      builder: (context, snapshot) {
        final completedCount = snapshot.data ?? 0;
        final totalCount = block.challenges.length;
        final isFullyCompleted = completedCount == totalCount;
        double progress =
            completedCount == 0 ? 0.01 : completedCount / totalCount;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: FccColors.gray75,
            ),
            color: FccColors.gray85,
          ),
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.calendar_today,
                      color: FccColors.gray00,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        block.monthYear,
                        style: TextStyle(
                          wordSpacing: 0,
                          letterSpacing: 0,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: FccColors.gray00,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                                  color: FccColors.blue30,
                                ),
                              ),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  color: FccColors.blue30,
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(FccColors.blue30),
                            backgroundColor: FccColors.gray80,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                ],
              ),
              ...parser.parse(
                '<p>${block.description}</p>',
                isSelectable: false,
                customStyles: {
                  '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': Style(
                    color: FccColors.gray05,
                  ),
                  'p': Style(margin: Margins.zero),
                },
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextButton(
                      onPressed: () => model.toggleBlock(block.monthYear),
                      style: TextButton.styleFrom(
                        backgroundColor: FccColors.gray85,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            color: FccColors.gray75,
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
              if (isOpen) buildChallengeList(context, block, model),
            ],
          ),
        );
      },
    );
  }

  Widget buildChallengeList(BuildContext context, DailyChallengeBlock block,
      DailyChallengeViewModel model) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width - 34,
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            physics: const ClampingScrollPhysics(),
            itemCount: block.challenges.length,
            itemBuilder: (context, challengeIndex) {
              final challenge = block.challenges[challengeIndex];
              return FutureBuilder<bool>(
                future: model.checkIfChallengeCompleted(challenge.id),
                builder: (context, snapshot) {
                  bool isCompleted = snapshot.data ?? false;
                  return InkWell(
                    onTap: () {
                      model.navigateToDailyChallenge(challenge);
                    },
                    child: Semantics(
                      label: isCompleted
                          ? 'Challenge ${challenge.challengeNumber}: ${challenge.title}, completed'
                          : 'Challenge ${challenge.challengeNumber}: ${challenge.title}, not completed',
                      button: true,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: isCompleted
                                ? const BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(0xbc, 0xe8, 0xf1, 1),
                                  )
                                : const BorderSide(
                                    color: Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                                  )),
                        color: isCompleted
                            ? Color.fromRGBO(0x00, 0x2e, 0xad, 0.3)
                            : const Color.fromRGBO(0x2a, 0x2a, 0x40, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              if (isCompleted)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Color.fromRGBO(0xbc, 0xe8, 0xf1, 1),
                                    size: 20,
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  'Challenge ${challenge.challengeNumber}: ${challenge.title}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
