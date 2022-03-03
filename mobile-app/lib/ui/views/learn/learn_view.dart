import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/learn_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class LearnView extends StatelessWidget {
  const LearnView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LearnViewModel>.reactive(
        viewModelBuilder: () => LearnViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(),
            resizeToAvoidBottomInset: false,
            drawer: const DrawerWidgetView(),
            body: ListView.builder(
                shrinkWrap: true,
                itemCount: model.superBlocks.length,
                itemBuilder: (BuildContext context, int i) {
                  dev.log(i.toString());
                  return Container(
                      height: 500,
                      child: superBlockBuilder(model.superBlocks[i], model));
                })));
  }

  FutureBuilder superBlockBuilder(String superBlockName, LearnViewModel model) {
    return FutureBuilder<SuperBlock>(
        future: model.getSuperBlockData(superBlockName),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            SuperBlock superBlock = snapshot.data as SuperBlock;

            return Text(superBlock.superblockName);
          }

          return const CircularProgressIndicator();
        }));
  }
}
