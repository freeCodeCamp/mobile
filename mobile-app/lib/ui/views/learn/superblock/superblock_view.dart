import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_view.dart';
import 'package:freecodecamp/ui/views/learn/superblock/superblock_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SuperBlockView extends StatelessWidget {
  const SuperBlockView({
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
    return ViewModelBuilder<SuperBlockViewModel>.reactive(
      viewModelBuilder: () => SuperBlockViewModel(),
      onViewModelReady: (model) => AuthenticationService.staticIsloggedIn
          ? model.auth.fetchUser()
          : null,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(superBlockName),
        ),
        backgroundColor: const Color.fromRGBO(0x0a, 0x0a, 0x23, 1),
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

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (model.blockOpenStates.isEmpty) {
                    Map<String, bool> openStates = {
                      if (superBlock.blocks != null)
                        for (var block in superBlock.blocks!)
                          block.dashedName: false
                    };

                    model.blockOpenStates = openStates;
                  }
                });

                return blockTemplate(model, superBlock);
              }
            }

            if (snapshot.hasError) {
              return Text(context.t.error);
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
    SuperBlockViewModel model,
    SuperBlock superBlock,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, block) {
                  return Padding(
                    padding: model.getPaddingBeginAndEnd(
                      block,
                      superBlock.blocks![block].challenges.length,
                    ),
                    child: Column(
                      children: [
                        BlockTemplateView(
                          key: ValueKey(block),
                          block: superBlock.blocks![block],
                          isOpen: model.blockOpenStates[
                                  superBlock.blocks![block].dashedName] ??
                              false,
                          isOpenFunction: () {
                            Map<String, bool> local = model.blockOpenStates;
                            Block curr = superBlock.blocks![block];

                            if (local[curr.dashedName] != null) {
                              local[curr.dashedName] = !local[curr.dashedName]!;
                            }

                            model.blockOpenStates = local;
                          },
                        )
                      ],
                    ),
                  );
                },
                childCount: superBlock.blocks!.length,
                addAutomaticKeepAlives: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
