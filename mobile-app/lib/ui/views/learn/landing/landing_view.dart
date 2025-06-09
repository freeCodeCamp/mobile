import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/landing/landing_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class LearnLandingView extends StatelessWidget {
  const LearnLandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LearnLandingViewModel>.reactive(
      viewModelBuilder: () => LearnLandingViewModel(),
      onViewModelReady: (model) => model.init(context),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(),
        drawer: const DrawerWidgetView(
          key: Key('drawer'),
        ),
        body: RefreshIndicator(
          backgroundColor: const Color(0xFF0a0a23),
          color: Colors.white,
          onRefresh: () {
            model.refresh();

            return Future.delayed(Duration.zero);
          },
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: FccColors.gray90,
                border: Border(),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  StreamBuilder(
                    stream: model.auth.isLoggedIn,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          if (model.isLoggedIn) welcomeMessage(model),
                        ],
                      );
                    },
                  ),
                  const QuoteWidget(),
                  if (!model.isLoggedIn) loginButton(model, context),
                  if (model.hasLastVisitedChallenge && model.isLoggedIn)
                    ContinueLearningButton(
                      model: model,
                    ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Our latest Curriculum',
                          style: model.headerStyle,
                        ),
                      ),
                      SuperBlockButton(
                        button: SuperBlockButtonData(
                          path: 'full-stack-developer',
                          name: 'Certified Full Stack Developer Curriculum',
                          public: true,
                        ),
                        model: model,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Learn English for developers',
                          style: model.headerStyle,
                        ),
                      ),
                      SuperBlockButton(
                        button: SuperBlockButtonData(
                          path: 'a2-english-for-developers',
                          name:
                              'A2 English for Developers (Beta) Certification',
                          public: true,
                        ),
                        model: model,
                      ),
                      SuperBlockButton(
                        button: SuperBlockButtonData(
                          path: 'b1-english-for-developers',
                          name:
                              ' B1 English for Developers (Beta) Certification',
                          public: true,
                        ),
                        model: model,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Our Legacy Courses',
                          style: model.headerStyle,
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<List<SuperBlockButtonData>>(
                    future: model.superBlockButtons,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return errorMessage(context);
                        }

                        if (snapshot.data is List<SuperBlockButtonData>) {
                          List<SuperBlockButtonData> buttons = snapshot.data!;

                          return ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: buttons.length,
                            itemBuilder: (BuildContext context, int i) {
                              return buttons[i].public
                                  ? SuperBlockButton(
                                      button: buttons[i],
                                      model: model,
                                    )
                                  : null;
                            },
                          );
                        }
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding errorMessage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width * 0.5,
        horizontal: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.t.error_three,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget loginButton(LearnLandingViewModel model, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0xf1, 0xbe, 0x32, 1),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              onPressed: () {
                model.auth.routeToLogin(true);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  context.t.login_save_progress,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget welcomeMessage(LearnLandingViewModel model) {
    return FutureBuilder<FccUserModel>(
      future: model.auth.userModel,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          FccUserModel user = snapshot.data as FccUserModel;

          return Text(
            context.t.login_welcome_back(
              user.username.startsWith('fcc') ? 'User' : user.username,
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}

class ContinueLearningButton extends StatelessWidget {
  const ContinueLearningButton({
    super.key,
    required this.model,
  });

  final LearnLandingViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 8,
      ),
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          model.fastRouteToChallenge();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(0x19, 0x8E, 0xEE, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Text(
                  context.t.continue_left_off,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
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
    );
  }
}

class SuperBlockButton extends StatelessWidget {
  const SuperBlockButton({
    super.key,
    required this.button,
    required this.model,
  });

  final LearnLandingViewModel model;
  final SuperBlockButtonData button;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 4,
      ),
      constraints: BoxConstraints(
        minHeight: 80,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5),
          backgroundColor: button.public
              ? FccColors.gray80
              : const Color.fromARGB(255, 41, 41, 54),
          side: button.public
              ? const BorderSide(
                  width: 2,
                  color: FccColors.gray75,
                )
              : const BorderSide(
                  width: 2,
                  color: Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: model.getRandomColor(),
                child: const Icon(
                  Icons.star,
                  color: FccColors.gray00,
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Text(
                button.name,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward_ios),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LearnLandingViewModel model = LearnLandingViewModel();

    return FutureBuilder(
      future: model.retrieveNewQuote(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          MotivationalQuote quote = snapshot.data as MotivationalQuote;

          return Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '"${quote.quote}"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '- ${quote.author}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }
}
