import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/pass/pass_widget_model.dart';
import 'package:stacked/stacked.dart';

class PassWidgetView extends StatelessWidget {
  const PassWidgetView({
    super.key,
    required this.challengeModel,
    required this.maxChallenges,
  });

  final ChallengeViewModel challengeModel;
  final int maxChallenges;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PassWidgetModel>.reactive(
      viewModelBuilder: () => PassWidgetModel(),
      onViewModelReady: (model) => model.initQuoute(),
      builder: (context, model, child) => SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    context.t.passed,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.87),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: model.quoteFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            MotivationalQuote quote =
                                snapshot.data as MotivationalQuote;
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                '"${quote.quote}"',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.87),
                                  fontSize: 20,
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
                          // Hide progress bar for daily challenges as the challenges technically aren't related.
                          // Also, if the user access the challenge from the landing page,
                          // we don't have the total challenges count to compute the progress.
                          if (AuthenticationService.staticIsloggedIn &&
                              !challengeModel.isDailyChallenge) {
                            return FutureBuilder(
                              future: model.numCompletedChallenges(
                                challengeModel,
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
                                          backgroundColor: const Color.fromRGBO(
                                              0x3B, 0x3B, 0x4F, 1),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                context.t.completed_percent(
                                                  ((completed * 100) /
                                                          maxChallenges)
                                                      .round()
                                                      .toString(),
                                                ),
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
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            0xf1, 0xbe, 0x32, 1),
                                        padding: const EdgeInsets.all(8),
                                        minimumSize: const Size.fromHeight(50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                      ),
                                      onPressed: () {
                                        model.auth.routeToLogin(true);
                                      },
                                      child: Text(
                                        context.t.login_save_progress,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
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
                      FutureBuilder(
                        future: model.numCompletedChallenges(challengeModel),
                        builder: (context, completedSnapshot) {
                          if (completedSnapshot.hasData) {
                            int completed = completedSnapshot.data as int;
                            return PassButton(
                              model: challengeModel,
                              maxChallenges: maxChallenges,
                              completed: completed - 1,
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PassButton extends StatelessWidget {
  const PassButton({
    super.key,
    required this.model,
    required this.maxChallenges,
    required this.completed,
  });

  final ChallengeViewModel model;
  final int maxChallenges;
  final int completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: () async {
          // Close the end drawer if open before navigating.
          // This is needed to ensure the back navigation works correctly.
          final scaffoldState = model.scaffoldKey.currentState;
          if (scaffoldState != null && scaffoldState.isEndDrawerOpen) {
            scaffoldState.closeEndDrawer();
            await Future.delayed(const Duration(milliseconds: 300));
          }

          model.closeWebViews();
          model.disposeOfListeners();

          model.learnService.goToNextChallenge(
            maxChallenges,
            model.challenge as Challenge,
            model.block as Block,
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromRGBO(60, 118, 61, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Text(
                context.t.next,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
