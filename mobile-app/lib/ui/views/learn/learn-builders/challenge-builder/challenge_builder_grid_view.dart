import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/challenge-builder/challenge_builder_model.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class ChallengeBuilderGridView extends StatelessWidget {
  final Block block;

  const ChallengeBuilderGridView({
    Key? key,
    required this.block,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeBuilderModel>.reactive(
        onModelReady: (model) => model.init(block.challenges),
        viewModelBuilder: () => ChallengeBuilderModel(),
        builder: (context, model, child) => Column(
              children: [
                Container(
                  color: const Color(0xFF0a0a23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (block.challenges.length == 1)
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(top: 8, left: 8),
                          color: const Color.fromRGBO(0x00, 0x2e, 0xad, 1),
                          child: const Text(
                            'Certification Porject',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0x19, 0x8e, 0xee, 1)),
                          ),
                        ),
                      ListTile(
                          onTap: () {
                            model.setIsOpen = !model.isOpen;
                          },
                          minVerticalPadding: 24,
                          trailing: block.challenges.length != 1
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        iconSize: 35,
                                        icon: model.isOpen
                                            ? const Icon(Icons.expand_less)
                                            : const Icon(Icons.expand_more),
                                        onPressed: () =>
                                            model.setIsOpen = !model.isOpen),
                                  ],
                                )
                              : null,
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (block.challenges.length != 1)
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                    child: model.challengesCompleted ==
                                            block.challenges.length
                                        ? const Icon(
                                            Icons.check_circle,
                                            size: 20,
                                          )
                                        : const Icon(Icons.circle_outlined,
                                            size: 20)),
                              Expanded(
                                child: Text(
                                  block.blockName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                if ((model.challengesCompleted / block.challenges.length * 100)
                        .round() >
                    0)
                  Container(
                    color: const Color(0xFF0a0a23),
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 1),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                color:
                                    const Color.fromRGBO(0x19, 0x8e, 0xee, 1),
                                backgroundColor:
                                    const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                                minHeight: 10,
                                value: model.challengesCompleted /
                                    block.challenges.length,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${(model.challengesCompleted / block.challenges.length * 100).round().toString()}%',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )),
                  ),
                if (model.isOpen || block.challenges.length == 1)
                  Container(
                    color: const Color(0xFF0a0a23),
                    child: InkWell(
                      onTap: block.challenges.length == 1
                          ? () {
                              String challenge = block.challenges[0].name
                                  .toLowerCase()
                                  .replaceAll(' ', '-');
                              String url =
                                  'https://freecodecamp.dev/page-data/learn';

                              model.routeToBrowserView(
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
                                  vertical: 8, horizontal: 16),
                              child: Text(
                                blockString,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                    fontFamily: 'Lato',
                                    color: Colors.white.withOpacity(0.87)),
                              ),
                            ),
                          buildDivider(),
                          if (block.challenges.length > 1)
                            gridWidget(context, model),
                          Container(
                            height: 25,
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ));
  }

  SizedBox gridWidget(BuildContext context, ChallengeBuilderModel model) {
    return SizedBox(
      height: 300,
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: (MediaQuery.of(context).size.width / 70 -
                MediaQuery.of(context).viewPadding.horizontal)
            .round(),
        children: List.generate(block.challenges.length, (step) {
          return Center(
              child: GridTile(
                  child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.01),
                          width: 1,
                        ),
                        color:
                            model.completedChallenge(block.challenges[step].id)
                                ? const Color.fromRGBO(0x00, 0x2e, 0xad, 1)
                                : Colors.transparent,
                      ),
                      height: 70,
                      width: 70,
                      child: InkWell(
                        onTap: () {
                          String challenge = block.challenges[step].name
                              .toLowerCase()
                              .replaceAll(' ', '-');
                          String url =
                              'https://freecodecamp.dev/page-data/learn';

                          model.routeToBrowserView(
                            '$url/${block.superBlock}/${block.dashedName}/$challenge/page-data.json',
                            block,
                          );
                        },
                        child: Center(
                            child: Text(
                          (step + 1).toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                      ))));
        }),
      ),
    );
  }
}
