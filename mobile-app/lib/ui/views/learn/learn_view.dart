import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/ui/views/learn/learn_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class LearnView extends StatelessWidget {
  const LearnView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LearnViewModel>.reactive(
        viewModelBuilder: () => LearnViewModel(),
        onModelReady: (model) => model.init(context),
        builder: (context, model, child) => Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
              resizeToAvoidBottomInset: false,
              backgroundColor: const Color(0xFF0a0a23),
              drawer: const DrawerWidgetView(),
              body: FutureBuilder(
                future: model.superBlocks,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var superBlocks = snapshot.data as List;
                    return ListView(shrinkWrap: true, children: [
                      quouteWidget(),
                      !model.auth.isLoggedIn ? loginButton(model) : Container(),
                      ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: superBlocks[0].length,
                          itemBuilder: (BuildContext context, int i) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, left: 8, right: 8),
                              child: superBlockBuilder(superBlocks[0][i],
                                  superBlocks[1][i], model, context),
                            );
                          }),
                    ]);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ));
  }

  Row superBlockBuilder(String superBlockSlug, String superBlockName,
      LearnViewModel model, BuildContext context) {
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
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: Text(
                        superBlockName,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_forward_ios)),
                  )
                ],
              )),
        ))
      ],
    );
  }

  Widget loginButton(LearnViewModel model) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
      height: 75,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: const Color.fromRGBO(0xf1, 0xbe, 0x32, 1)),
          onPressed: () {
            model.auth.login();
          },
          child: const Text(
            'Sign in to save your progress ',
            style: TextStyle(color: Colors.black, fontSize: 20),
          )),
    );
  }

  Widget quouteWidget() {
    LearnViewModel model = LearnViewModel();

    return FutureBuilder(
        future: model.retrieveNewQuote(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            MotivationalQuote quote = snapshot.data as MotivationalQuote;

            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '"${quote.quote}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, height: 1.5),
                  ),
                  Text(
                    '- ${quote.author}',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 16, height: 1.5),
                  )
                ],
              ),
            );
          }

          return Container();
        });
  }
}
