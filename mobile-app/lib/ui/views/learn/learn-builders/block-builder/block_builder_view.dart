import 'package:flutter/material.dart' show BuildContext, Color, Column, Container, CrossAxisAlignment, EdgeInsets, FontWeight, Key, MainAxisAlignment, Padding, StatelessWidget, Text, TextAlign, TextStyle, Widget;
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/block-builder/block_builder_model.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/challenge-builder/challenge_builder_grid_view.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/challenge-builder/challenge_builder_list_view.dart';
import 'package:stacked/stacked.dart';

class BlockBuilderView extends StatelessWidget {
  const BlockBuilderView({
    Key? key,
    required this.block,
  }) : super(key: key);

  final Block block;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BlockBuilderModel>.reactive(
        viewModelBuilder: () => BlockBuilderModel(),
        builder: (context, model, child) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Column(
                    children: [
                      Container(
                        color: const Color(0xFF0a0a23),
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              block.blockName,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                block.description,
                                style: const TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ),
                      !block.isStepBased
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ChallengeBuilderListView(
                                block: block,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ChallengeBuilderGridView(
                                block: block,
                              ),
                            )
                    ],
                  ),
                ),
              ],
            ));
  }
}
