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
        child: ListView.separated(
          separatorBuilder: (context, int i) => const Divider(
            height: 0,
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
                BlockTemplateView(
                  block: superBlock.blocks![i],
                  isOpen: superBlock.blocks!.length <= 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
