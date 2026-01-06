import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/landing/landing_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/daily_challenge_card.dart';
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
        backgroundColor: FccColors.gray90,
        appBar: AppBar(
          title: Text('LEARN'),
        ),
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
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: FccColors.gray90,
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
                  const SizedBox(height: 16),
                  DailyChallengeCard(
                    dailyChallenge: model.dailyChallenge,
                    isCompleted: model.isDailyChallengeCompleted,
                  ),
                  const SizedBox(height: 16),
                  if (model.isBusy)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    FutureBuilder<List<Widget>>(
                      future: model.superBlockButtons,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return errorMessage(context);
                          }

                          if (snapshot.data is List<Widget>) {
                            List<Widget> widgets = snapshot.data!;

                            return ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widgets.length,
                              itemBuilder: (BuildContext context, int i) {
                                return widgets[i];
                              },
                            );
                          }
                        }

                        return errorMessage(context);
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

class SuperBlockButton extends StatelessWidget {
  SuperBlockButton({
    super.key,
    required this.button,
    required this.model,
  });

  final LearnLandingViewModel model;
  final SuperBlockButtonData button;

  static const String learnAssetsPath = 'assets/learn';

  final iconMap = {
    SuperBlocks.respWebDesignV9:
        '${SuperBlockButton.learnAssetsPath}/responsive-design.svg',
    SuperBlocks.javascriptV9:
        '${SuperBlockButton.learnAssetsPath}/javascript.svg',
    SuperBlocks.frontEndDevLibsV9:
        '${SuperBlockButton.learnAssetsPath}/react.svg',
    SuperBlocks.pythonV9: '${SuperBlockButton.learnAssetsPath}/python.svg',
    SuperBlocks.relationalDbV9:
        '${SuperBlockButton.learnAssetsPath}/database.svg',
    SuperBlocks.backEndDevApisV9: '${SuperBlockButton.learnAssetsPath}/api.svg',
    SuperBlocks.respWebDesignNew:
        '${SuperBlockButton.learnAssetsPath}/responsive-design.svg',
    SuperBlocks.respWebDesign:
        '${SuperBlockButton.learnAssetsPath}/responsive-design.svg',
    SuperBlocks.jsAlgoDataStruct:
        '${SuperBlockButton.learnAssetsPath}/javascript.svg',
    SuperBlocks.jsAlgoDataStructNew:
        '${SuperBlockButton.learnAssetsPath}/javascript.svg',
    SuperBlocks.frontEndDevLibs:
        '${SuperBlockButton.learnAssetsPath}/react.svg',
    SuperBlocks.dataVis: '${SuperBlockButton.learnAssetsPath}/d3.svg',
    SuperBlocks.backEndDevApis: '${SuperBlockButton.learnAssetsPath}/api.svg',
    SuperBlocks.relationalDb:
        '${SuperBlockButton.learnAssetsPath}/database.svg',
    SuperBlocks.qualityAssurance:
        '${SuperBlockButton.learnAssetsPath}/clipboard.svg',
    SuperBlocks.sciCompPy: '${SuperBlockButton.learnAssetsPath}/python.svg',
    SuperBlocks.dataAnalysisPy:
        '${SuperBlockButton.learnAssetsPath}/analytics.svg',
    SuperBlocks.infoSec: '${SuperBlockButton.learnAssetsPath}/shield.svg',
    SuperBlocks.machineLearningPy:
        '${SuperBlockButton.learnAssetsPath}/tensorflow.svg',
    SuperBlocks.codingInterviewPrep:
        '${SuperBlockButton.learnAssetsPath}/algorithm.svg',
    SuperBlocks.theOdinProject:
        '${SuperBlockButton.learnAssetsPath}/viking-helmet.svg',
    SuperBlocks.projectEuler:
        '${SuperBlockButton.learnAssetsPath}/graduation.svg',
    SuperBlocks.collegeAlgebraPy:
        '${SuperBlockButton.learnAssetsPath}/college-algebra.svg',
    SuperBlocks.foundationalCSharp:
        '${SuperBlockButton.learnAssetsPath}/c-sharp.svg',
    SuperBlocks.fullStackDeveloper:
        '${SuperBlockButton.learnAssetsPath}/code.svg',
    SuperBlocks.a2English: '${SuperBlockButton.learnAssetsPath}/a2-english.svg',
    SuperBlocks.b1English: '${SuperBlockButton.learnAssetsPath}/b1-english.svg',
    SuperBlocks.a2Spanish: '${SuperBlockButton.learnAssetsPath}/a2-english.svg',
    SuperBlocks.a1Spanish: '${SuperBlockButton.learnAssetsPath}/a2-english.svg',
    SuperBlocks.a1Chinese: '${SuperBlockButton.learnAssetsPath}/a2-english.svg',
    SuperBlocks.rosettaCode:
        '${SuperBlockButton.learnAssetsPath}/rosetta-code.svg',
    SuperBlocks.pythonForEverybody:
        '${SuperBlockButton.learnAssetsPath}/python.svg',
    SuperBlocks.devPlayground: '${SuperBlockButton.learnAssetsPath}/code.svg',
  };

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
          backgroundColor: button.public ? FccColors.gray80 : FccColors.gray75,
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
              child: SizedBox(
                width: 36,
                height: 36,
                child: SvgPicture.asset(
                  iconMap[SuperBlocks.fromValue(button.path)] ??
                      '${SuperBlockButton.learnAssetsPath}/graduation.svg',
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    FccColors.gray00,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Text(
                button.name,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Icon(Icons.arrow_forward_ios),
                ),
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
