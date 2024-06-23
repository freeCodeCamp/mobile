import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';

import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/block/block_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/download_button_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/open_close_icon_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/progressbar_widget.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';

import 'package:stacked/stacked.dart';

class BlockView extends StatelessWidget {
  final Block block;
  final bool isOpen;
  final bool isStepBased;

  const BlockView({
    Key? key,
    required this.block,
    required this.isOpen,
    required this.isStepBased,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BlockViewModel>.reactive(
      onViewModelReady: (model) async {
        model.init(block.challengeTiles);
        model.setIsOpen = isOpen;
        model.setIsDownloaded = await model.isBlockDownloaded(block);
        model.setIsDev = await model.developerService.developmentMode();
      },
      viewModelBuilder: () => BlockViewModel(),
      builder: (
        context,
        model,
        child,
      ) {
        bool isCertification = block.challenges.length == 1 &&
            block.superBlock.dashedName != 'the-odin-project';

        int calculateProgress =
            (model.challengesCompleted / block.challenges.length * 100).round();

        bool hasProgress = calculateProgress > 0;

        HTMLParser parser = HTMLParser(context: context);

        return Column(
          children: [
            BlockHeader(
              isCertification: isCertification,
              block: block,
              model: model,
            ),
            if (hasProgress && isStepBased)
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
                          model.routeToCertification(block);
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
                          child: Wrap(
                            children: parser.parse('<p>$blockString</p>',
                                fontColor: Colors.white),
                          ),
                        ),
                      if (model.isDev && !isCertification)
                        DownloadButton(
                          model: model,
                          block: block,
                        ),
                      if (!isCertification && isStepBased) ...[
                        buildDivider(),
                        gridWidget(context, model)
                      ],
                      if (!isStepBased && !isCertification) ...[
                        buildDivider(),
                        listWidget(context, model)
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

  Widget gridWidget(BuildContext context, BlockViewModel model) {
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

  Widget listWidget(BuildContext context, BlockViewModel model) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: block.challenges.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, i) => ListTile(
            leading: model.getIcon(
              model.completedChallenge(
                block.challengeTiles[i].id,
              ),
            ),
            title: Text(block.challengeTiles[i].name),
            onTap: () async {
              String challengeId = block.challengeTiles[i].id;

              String url = LearnService.baseUrl;

              model.routeToChallengeView(
                '$url/challenges/${block.superBlock.dashedName}/${block.dashedName}/$challengeId.json',
                block,
                challengeId,
              );
            },
          ),
        ),
      ],
    );
  }
}

class BlockHeader extends StatelessWidget {
  const BlockHeader({
    Key? key,
    required this.isCertification,
    required this.block,
    required this.model,
  }) : super(key: key);

  final bool isCertification;
  final BlockViewModel model;
  final Block block;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0a0a23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCertification)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(top: 8, left: 8),
              color: const Color.fromRGBO(0x00, 0x2e, 0xad, 1),
              child: Text(
                context.t.certification_project,
                style: const TextStyle(
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
            minVerticalPadding: 18,
            leading: !isCertification
                ? model.challengesCompleted == block.challenges.length
                    ? const Icon(
                        Icons.check_circle,
                        size: 20,
                      )
                    : const Icon(
                        Icons.circle_outlined,
                        size: 20,
                      )
                : null,
            trailing: !isCertification
                ? OpenCloseIcon(
                    block: block,
                    model: model,
                  )
                : null,
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    block.name,
                    maxLines: model.isOpen ? 5 : 2,
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
  final BlockViewModel model;
  final int step;
  final bool isDowloaded;

  @override
  Widget build(BuildContext context) {
    bool isCompleted = model.completedChallenge(
      block.challengeTiles[step].id,
    );

    return GridTile(
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDowloaded && model.isDownloading && isCompleted
                ? Colors.green
                : Colors.white.withOpacity(0.01),
            width: isDowloaded && model.isDownloading && isCompleted ? 5 : 1,
          ),
          color: isCompleted
              ? const Color.fromRGBO(0x00, 0x2e, 0xad, 1)
              : isDowloaded && model.isDownloading && !isCompleted
                  ? Colors.green
                  : Colors.transparent,
        ),
        height: 70,
        width: 70,
        child: InkWell(
          onTap: () async {
            String challengeId = block.challengeTiles[step].id;

            String url = LearnService.baseUrl;

            String fullUrl =
                '$url/challenges/${block.superBlock.dashedName}/${block.dashedName}/$challengeId.json';

            model.routeToChallengeView(
              fullUrl,
              block,
              challengeId,
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
