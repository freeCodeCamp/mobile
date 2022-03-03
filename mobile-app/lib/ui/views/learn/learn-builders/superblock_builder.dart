import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/block_builder.dart';
import 'package:freecodecamp/ui/views/learn/learn_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SuperBlockView extends StatelessWidget {
  const SuperBlockView({Key? key, required this.superBlockName})
      : super(key: key);

  final String superBlockName;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LearnViewModel>.reactive(
        viewModelBuilder: () => LearnViewModel(),
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
      child: ListView.separated(
        separatorBuilder: (context, int i) => const Divider(
          height: 50,
          color: Color.fromRGBO(0, 0, 0, 0),
        ),
        shrinkWrap: true,
        itemCount: superBlock.blocks.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, i) => BlockBuilder(
          model: model,
          block: superBlock.blocks[i],
        ),
      ),
    );
  }
}
