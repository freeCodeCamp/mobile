import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/challenge-builder/challenge_builder_model.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class ChallengeBuilderGridView extends StatelessWidget {
  final Block block;

  const ChallengeBuilderGridView({
    Key? key,
    required this.block,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeBuilderModel>.reactive(
        viewModelBuilder: () => ChallengeBuilderModel(),
        builder: (context, model, child) => Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    color: const Color(0xFF0a0a23),
                    child: GridView.count(
                      crossAxisCount: 5,
                      children: List.generate(block.challenges.length, (index) {
                        dev.log('hello');
                        return Center(
                            child: InkWell(
                          child: GridTile(child: Text(index.toString())),
                          onTap: () {
                            String challenge = block.challenges[index].name
                                .toLowerCase()
                                .replaceAll(' ', '-');
                            String url =
                                'https://freecodecamp.dev/page-data/learn';

                            model.routeToBrowserView(
                                '$url/${block.superBlock}/${block.dashedName}/$challenge/page-data.json');
                          },
                        ));
                      }),
                    )),
              ],
            ));
  }
}
