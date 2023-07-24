import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/dynamic_panel/panels/pass/pass_widget_model.dart';
import 'package:stacked/stacked.dart';

class PassWidgetView extends StatelessWidget {
  const PassWidgetView({
    Key? key,
    required this.challengeModel,
    required this.challengesCompleted,
    required this.maxChallenges,
  }) : super(key: key);

  final ChallengeViewModel challengeModel;
  final int challengesCompleted;
  final int maxChallenges;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PassWidgetModel>.reactive(
      viewModelBuilder: () => PassWidgetModel(),
      onViewModelReady: (model) => model.init(),
      builder: (context, model, child) => SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Passed',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.87),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        challengeModel.setShowPanel = false;
                      },
                      icon: const Icon(Icons.clear_sharp),
                      iconSize: 40,
                    ),
                  ),
                )
              ],
            ),
            FutureBuilder(
              future: model.retrieveNewQuote(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  MotivationalQuote quote = snapshot.data as MotivationalQuote;
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '"${quote.quote}"',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.87),
                        fontSize: 20,
                        fontFamily: 'Inter',
                      ),
                    ),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            StreamBuilder<bool>(
              stream: AuthenticationService.isLoggedInStream.stream,
              builder: (context, snapshot) {
                if (AuthenticationService.staticIsloggedIn) {
                  return FutureBuilder(
                    future: model.numCompletedChallenges(
                      challengeModel,
                      challengesCompleted,
                    ),
                    builder: (context, completedSnapshot) {
                      if (completedSnapshot.hasData) {
                        int completed = completedSnapshot.data as int;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: LinearProgressIndicator(
                                value: completed / maxChallenges,
                                minHeight: 7,
                                backgroundColor:
                                    const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${(completed * 100) ~/ maxChallenges}% Completed',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                } else if (!AuthenticationService.staticIsloggedIn) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(0xf1, 0xbe, 0x32, 1),
                              padding: const EdgeInsets.all(8),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            onPressed: () {
                              model.auth.routeToLogin(true);
                            },
                            child: const Text(
                              'Sign in to save your progress',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Center(child: Container());
              },
            ),
            PassButton(
              model: challengeModel,
              maxChallenges: maxChallenges,
              completed: challengesCompleted,
            ),
          ],
        ),
      ),
    );
  }
}

class PassButton extends StatelessWidget {
  const PassButton({
    Key? key,
    required this.model,
    required this.maxChallenges,
    required this.completed,
  }) : super(key: key);

  final ChallengeViewModel model;
  final int maxChallenges;
  final int completed;

  @override
  Widget build(BuildContext context) {
    MaterialStateProperty<Color?> myColorProperty =
        MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey;
        }
        return const Color.fromRGBO(0x20, 0xD0, 0x32, 1);
      },
    );

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: () async {
          model.learnService.goToNextChallenge(
            maxChallenges,
            completed,
            await model.challenge as Challenge,
            model.block as Block,
          );
        },
        style: ButtonStyle(
          backgroundColor: myColorProperty,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const FaIcon(FontAwesomeIcons.arrowRight)
          ],
        ),
      ),
    );
  }
}
