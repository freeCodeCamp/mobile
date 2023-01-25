import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/ui/views/learn/learn/learn_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class LearnView extends StatelessWidget {
  const LearnView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LearnViewModel>.reactive(
      viewModelBuilder: () => LearnViewModel(),
      onViewModelReady: (model) => model.init(context),
      builder: (context, model, child) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('LEARN'),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF0a0a23),
        drawer: const DrawerWidgetView(),
        body: RefreshIndicator(
          backgroundColor: const Color(0xFF0a0a23),
          color: Colors.white,
          onRefresh: () {
            model.refresh();

            return Future.delayed(Duration.zero);
          },
          child: FutureBuilder<List<SuperBlockButton>>(
            future: model.getSuperBlocks(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return errorMessage(context);
                }

                List<SuperBlockButton> buttons =
                    snapshot.data as List<SuperBlockButton>;

                return ListView(
                  shrinkWrap: true,
                  children: [
                    StreamBuilder(
                      stream: model.auth.isLoggedIn,
                      builder: ((context, snapshot) {
                        return Column(
                          children: [
                            quouteWidget(),
                            if (!model.isLoggedIn)
                              loginButton(model, context)
                            else
                              welcomeMessage(model)
                          ],
                        );
                      }),
                    ),
                    ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: buttons.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            left: 8,
                            right: 8,
                          ),
                          child: superBlockBuilder(
                            buttons[i],
                            context,
                          ),
                        );
                      },
                    ),
                    Container(
                      height: 50,
                    )
                  ],
                );
              }

              if (ConnectionState.waiting == snapshot.connectionState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  ListView errorMessage(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.5,
            horizontal: 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'You are offline, and have no downloads!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Try to download some challenges if you have an unstable connection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 2.2,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row superBlockBuilder(SuperBlockButton button, BuildContext context) {
    LearnViewModel model = LearnViewModel();

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 75,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: button.public
                    ? const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1)
                    : const Color.fromARGB(255, 41, 41, 54),
                side: button.public
                    ? const BorderSide(width: 2, color: Colors.white)
                    : const BorderSide(
                        width: 2,
                        color: Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                      ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                  side: const BorderSide(
                    color: Colors.teal,
                    width: 2.0,
                  ),
                ),
              ),
              onPressed: () {
                button.public
                    ? model.routeToSuperBlock(button.path, button.name)
                    : model.disabledButtonSnack();
              },
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: Text(
                        button.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget loginButton(LearnViewModel model, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
      constraints: const BoxConstraints(minHeight: 75),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(0xf1, 0xbe, 0x32, 1),
        ),
        onPressed: () {
          model.auth.login(context);
        },
        child: const Text(
          'Sign in to save your progress',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
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
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    height: 1.5,
                  ),
                )
              ],
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget welcomeMessage(LearnViewModel model) {
    return FutureBuilder<FccUserModel>(
      future: model.auth.userModel,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          FccUserModel user = snapshot.data as FccUserModel;

          return Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Welcome back ${user.username}. ',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
