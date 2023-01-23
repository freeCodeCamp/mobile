import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/ui/views/learn/block/block_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/superblock/superblock_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LearnSuperBlockView extends StatelessWidget {
  const LearnSuperBlockView({
    Key? key,
    required this.superBlockDashedName,
    required this.superBlockName,
    required this.hasInternet,
  }) : super(key: key);

  final String superBlockDashedName;
  final String superBlockName;
  final bool hasInternet;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LearnBlockViewModel>.reactive(
      viewModelBuilder: () => LearnBlockViewModel(),
      onViewModelReady: (model) => AuthenticationService.staticIsloggedIn
          ? model.auth.fetchUser()
          : null,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(superBlockName),
        ),
        body: FutureBuilder<SuperBlock>(
          future: model.getSuperBlockData(
            superBlockDashedName,
            superBlockName,
            hasInternet,
          ),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data is SuperBlock) {
                SuperBlock superBlock = snapshot.data as SuperBlock;

                if (superBlock.blocks == null || superBlock.blocks!.isEmpty) {
                  return const Text('You are offline, and no downloads!');
                }
                return blockTemplate(model, superBlock);
              }
            }

            if (snapshot.hasError) {
              return const Text('Something whent wrong, please refresh!');
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
        ),
      ),
    );
  }

  Widget blockTemplate(
    LearnBlockViewModel model,
    SuperBlock superBlock,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: ListView.separated(
          separatorBuilder: (context, int i) => Divider(
            height: model.getPaddingBetweenBlocks(superBlock.blocks![i]),
            color: Colors.transparent,
          ),
          shrinkWrap: true,
          itemCount: superBlock.blocks!.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, i) => Padding(
            padding: model.getPaddingBeginAndEnd(
              i,
              superBlock.blocks![i].challenges.length,
            ),
            child: Column(
              children: [
                FutureBuilder<bool>(
                  future: model.getBlockOpenState(superBlock.blocks![i]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      bool isOpen = snapshot.data!;

                      return BlockView(
                        block: superBlock.blocks![i],
                        isOpen: isOpen,
                        isStepBased: superBlock.blocks![i].isStepBased,
                      );
                    }

                    return const CircularProgressIndicator();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
