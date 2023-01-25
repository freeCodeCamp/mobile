import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/challenge-builder/challenge_builder_model.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';

import 'package:stacked/stacked.dart';

class ChallengeBuilderGridView extends StatelessWidget {
  final Block block;
  final bool isOpen;

  const ChallengeBuilderGridView({
    Key? key,
    required this.block,
    required this.isOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeBuilderModel>.reactive(
      onViewModelReady: (model) async {
        model.init(block.challengeTiles);
        model.setIsOpen = isOpen;
        model.setIsDownloaded = await model.isBlockDownloaded(block);
        model.setIsDev = await model.developerService.developmentMode();
      },
      viewModelBuilder: () => ChallengeBuilderModel(),
      builder: (
        context,
        model,
        child,
      ) {
        bool isCertification = block.challenges.length == 1;

        int calculateProgress =
            (model.challengesCompleted / block.challenges.length * 100).round();

        bool hasProgress = calculateProgress > 0;

        return Column(
          children: [
            Container(
              color: const Color(0xFF0a0a23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isCertification)
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(top: 8, left: 8),
                      color: const Color.fromRGBO(0x00, 0x2e, 0xad, 1),
                      child: const Text(
                        'Certification Project',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0x19, 0x8e, 0xee, 1),
                        ),
                      ),
                    ),
                  ListTile(
                    onTap: () {
                      model.setBlockOpenState(
                        block.name,
                        model.isOpen,
                      );
                    },
                    minVerticalPadding: 24,
                    trailing: !isCertification
                        ? OpenCloseIconWidget(
                            block: block,
                            model: model,
                          )
                        : null,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!isCertification)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                            child: model.challengesCompleted ==
                                    block.challenges.length
                                ? const Icon(
                                    Icons.check_circle,
                                    size: 20,
                                  )
                                : const Icon(
                                    Icons.circle_outlined,
                                    size: 20,
                                  ),
                          ),
                        Expanded(
                          child: Text(
                            block.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (hasProgress)
              ChallengeProgressBar(
                block: block,
                model: model,
              ),
            if (model.isOpen || isCertification)
              Container(
                color: const Color(0xFF0a0a23),
                child: InkWell(
                  onTap: isCertification
                      ? () async {
                          String challenge = block.challengeTiles[0].dashedName;

                          String url = await model.learnService.getBaseUrl(
                            '/page-data/learn',
                          );

                          model.routeToChallengeView(
                            '$url/${block.superBlock}/${block.dashedName}/$challenge/page-data.json',
                            block,
                          );
                        }
                      : () {},
                  child: Column(
                    children: [
                      for (String blockString in block.description)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: Text(
                            blockString,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              fontFamily: 'Lato',
                              color: Colors.white.withOpacity(0.87),
                            ),
                          ),
                        ),
                      if (model.isDev)
                        DownloadWidget(
                          model: model,
                          block: block,
                        ),
                      if (!isCertification) ...[
                        buildDivider(),
                        gridWidget(context, model)
                      ],
                      Container(
                        height: 25,
                      )
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  SizedBox gridWidget(BuildContext context, ChallengeBuilderModel model) {
    return SizedBox(
      height: 300,
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: (MediaQuery.of(context).size.width / 70 -
                MediaQuery.of(context).viewPadding.horizontal)
            .round(),
        children: List.generate(
          block.challenges.length,
          (step) {
            return FutureBuilder(
              future: model.isChallengeDownloaded(
                block.challengeTiles[step].id,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: ChallengeTile(
                      block: block,
                      model: model,
                      step: step,
                      isDowloaded: (snapshot.data is bool
                          ? snapshot.data as bool
                          : false),
                    ),
                  );
                }

                return const CircularProgressIndicator();
              },
            );
          },
        ),
      ),
    );
  }
}

class ChallengeTile extends StatelessWidget {
  const ChallengeTile({
    Key? key,
    required this.block,
    required this.model,
    required this.step,
    required this.isDowloaded,
  }) : super(key: key);

  final Block block;
  final ChallengeBuilderModel model;
  final int step;
  final bool isDowloaded;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(0.01),
            width: 1,
          ),
          color: model.completedChallenge(
            block.challengeTiles[step].id,
          )
              ? const Color.fromRGBO(0x00, 0x2e, 0xad, 1)
              : isDowloaded && model.isDownloading
                  ? Colors.green
                  : Colors.transparent,
        ),
        height: 70,
        width: 70,
        child: InkWell(
          onTap: () async {
            String challenge = block.challenges[step].dashedName;

            String url = await model.learnService.getBaseUrl(
              '/page-data/learn',
            );

            model.routeToChallengeView(
              '$url/${block.superBlock}/${block.dashedName}/$challenge/page-data.json',
              block,
            );
          },
          child: Center(
            child: Text(
              (step + 1).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DownloadWidget extends StatelessWidget {
  const DownloadWidget({
    Key? key,
    required this.model,
    required this.block,
  }) : super(key: key);

  final ChallengeBuilderModel model;
  final Block block;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!model.isDownloaded || model.isDownloading)
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: !model.isDownloading
                  ? () async {
                      await model.startDownload(block);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              ),
              child: !model.isDownloading
                  ? const Text('Download All Challenges')
                  : StreamBuilder(
                      stream: model.learnOfflineService.downloadStream.stream,
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Starting Download...');
                        }

                        // if (snapshot.hasError) {
                        //   model.stopDownload(block.dashedName);

                        //   Timer(const Duration(seconds: 5), () {
                        //     model.setIsDownloading = false;
                        //   });

                        //   return const Text('An Error has Occured');
                        // }

                        if (snapshot.hasData) {
                          return Text(
                            '${(snapshot.data as double).toStringAsFixed(2)}%',
                          );
                        }

                        return const Text(
                          'Download All Challenges',
                        );
                      }),
                    ),
            ),
          ),
        if (model.isDownloaded || model.isDownloading)
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () async {
                model.isDownloading
                    ? model.stopDownload(block, false)
                    : model.stopDownload(block, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              ),
              child: model.isDownloading
                  ? const Text('Cancel Downloading Challenges')
                  : const Text('Delete Downloaded Challenges'),
            ),
          )
      ],
    );
  }
}

class ChallengeProgressBar extends StatelessWidget {
  const ChallengeProgressBar({
    Key? key,
    required this.block,
    required this.model,
  }) : super(key: key);

  final Block block;
  final ChallengeBuilderModel model;

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

class OpenCloseIconWidget extends StatelessWidget {
  const OpenCloseIconWidget({
    Key? key,
    required this.block,
    required this.model,
  }) : super(key: key);

  final Block block;
  final ChallengeBuilderModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 35,
          icon: model.isOpen
              ? const Icon(Icons.expand_less)
              : const Icon(Icons.expand_more),
          onPressed: () async {
            model.setBlockOpenState(
              block.name,
              model.isOpen,
            );
          },
        ),
      ],
    );
  }
}
