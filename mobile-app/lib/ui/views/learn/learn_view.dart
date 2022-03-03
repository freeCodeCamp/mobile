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
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 8, right: 8),
                    child: superBlockBuilder(model.superBlocks[i], model),
                  );
                })));
  }

  Row superBlockBuilder(String superBlockName, LearnViewModel viewModel) {
    return Row(
      children: [
        Expanded(
            child: SizedBox(
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                side: const BorderSide(width: 2, color: Colors.white),
              ),
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  SuperBlock.getSuperBlockName(superBlockName),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 20),
                ),
              )),
        ))
      ],
    );
  }
}
