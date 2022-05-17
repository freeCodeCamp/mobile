import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/learn/learn_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class LearnView extends StatelessWidget {
  const LearnView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LearnViewModel>.reactive(
        viewModelBuilder: () => LearnViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
              resizeToAvoidBottomInset: false,
              drawer: const DrawerWidgetView(),
              body: FutureBuilder(
                future: model.superBlocks,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var superBlocks = snapshot.data as List;
                    return Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Image.asset(
                                'assets/images/freecodecamp-banner.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: const [
                                    Text(
                                      'Choose your course',
                                      style: TextStyle(
                                          fontSize: 26,
                                          height: 2,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'We recommend starting at the beginning',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                )),
                            AppBar(
                              shadowColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: superBlocks[0].length,
                              itemBuilder: (BuildContext context, int i) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, left: 8, right: 8),
                                  child: superBlockBuilder(superBlocks[0][i],
                                      superBlocks[1][i], model),
                                );
                              }),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ));
  }

  Row superBlockBuilder(
      String superBlockSlug, String superBlockName, LearnViewModel model) {
    return Row(
      children: [
        Expanded(
            child: SizedBox(
          height: 75,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                side: const BorderSide(width: 2, color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                  side: const BorderSide(
                    color: Colors.teal,
                    width: 2.0,
                  ),
                ),
              ),
              onPressed: () {
                model.routeToSuperBlock(superBlockSlug);
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  superBlockName,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 20),
                ),
              )),
        ))
      ],
    );
  }
}
