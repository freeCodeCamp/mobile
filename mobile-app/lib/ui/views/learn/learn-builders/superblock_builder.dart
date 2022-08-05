import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/block-builder/block_builder_view.dart';
import 'package:freecodecamp/ui/views/learn/learn/learn_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SuperBlockView extends StatelessWidget {
  const SuperBlockView({Key? key, required this.superBlockName})
      : super(key: key);

  final String superBlockName;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LearnViewModel>.reactive(
        viewModelBuilder: () => LearnViewModel(),
        onModelReady: (model) => AuthenticationService.staticIsloggedIn
            ? model.auth.fetchUser()
            : null,
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(),
              body: FutureBuilder<SuperBlock>(
                  future: model.getSuperBlockData(superBlockName),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      SuperBlock superBlock = snapshot.data as SuperBlock;

                      return superBlockTemplate(model, superBlock);
                    }

                    return const Center(child: CircularProgressIndicator());
                  })),
            ));
  }

  Widget superBlockTemplate(LearnViewModel model, SuperBlock superBlock) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: ListView.separated(
          separatorBuilder: (context, int i) => Divider(
            height: superBlock.blocks[i].challenges.length == 1
                ? 50
                : superBlock.blocks[i].isStepBased
                    ? 3
                    : 50,
            color: const Color.fromRGBO(0, 0, 0, 0),
          ),
          shrinkWrap: true,
          itemCount: superBlock.blocks.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, i) => Padding(
            padding: i == 0 ? const EdgeInsets.only(top: 16) : EdgeInsets.zero,
            child: BlockBuilderView(
              key: ObjectKey(superBlock.blocks[i].dashedName),
              block: superBlock.blocks[i],
            ),
          ),
        ),
      ),
    );
  }
}
