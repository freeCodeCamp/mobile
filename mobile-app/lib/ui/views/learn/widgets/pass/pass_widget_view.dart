import 'package:flutter/material.dart';
import 'package:freecodecamp/enums/alert_type.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/widgets/custom_alert_widget.dart';
import 'package:freecodecamp/ui/views/learn/widgets/pass/pass_widget_model.dart';
import 'package:stacked/stacked.dart';

class PassWidgetView extends StatelessWidget {
  const PassWidgetView({
    Key? key,
    required this.challengeModel,
    required this.challengesCompleted,
    required this.maxChallenges,
  }) : super(key: key);

  final ChallengeModel challengeModel;
  final int challengesCompleted;
  final int maxChallenges;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PassWidgetModel>.reactive(
      viewModelBuilder: () => PassWidgetModel(),
      onModelReady: (model) => model.init(),
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
                        color: Colors.white.withOpacity(0.87)),
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
                    MotivationalQuote quote =
                        snapshot.data as MotivationalQuote;
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '"${quote.quote}"',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.87),
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                      ),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            // if(AuthenticationService.staticIsloggedIn)
            //     FutureBuilder(
            //         future: model.numCompletedChallenges(
            //             challengeModel, challengesCompleted),
            //         builder: (context, snapshot) {
            //           if (snapshot.hasData) {
            //             int numCompletedChallenges = snapshot.data as int;
            //             return Column(
            //               children: [
            //                 Padding(
            //                   padding: const EdgeInsets.all(16.0),
            //                   child: LinearProgressIndicator(
            //                     value: numCompletedChallenges / maxChallenges,
            //                     minHeight: 7,
            //                     backgroundColor:
            //                         const Color.fromRGBO(0x3B, 0x3B, 0x4F, 1),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding:
            //                       const EdgeInsets.symmetric(horizontal: 16),
            //                   child: Row(
            //                     children: [
            //                       Expanded(
            //                         child: Text(
            //                           '${(numCompletedChallenges * 100) ~/ maxChallenges}% Completed',
            //                           textAlign: TextAlign.right,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ],
            //             );
            //           }

            //           return const Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         },
            //       )
            //     : Container(
            //         padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
            //         constraints: const BoxConstraints(minHeight: 75),
            //         child: ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: const Color.fromRGBO(0xf1, 0xbe, 0x32, 1),
            //             padding: const EdgeInsets.all(8),
            //           ),
            //           onPressed: () {
            //             model.auth.login(context);
            //           },
            //           child: const Text(
            //             'Sign in to save your progress',
            //             textAlign: TextAlign.center,
            //             style: TextStyle(color: Colors.black, fontSize: 20),
            //           ),
            //         ),
            //       ),
            const CustomAlert(
              text:
                  "Note: We're still working on the ability to save your progress. To claim certifications, you'll need to submit your projects through freeCodeCamp's website.",
              alertType: Alert.warning,
            ),
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.share_sharp),
                  //   padding: const EdgeInsets.all(16),
                  // ),
                  IconButton(
                    onPressed: () {
                      challengeModel.setShowPreview = true;
                      challengeModel.setShowPanel = false;
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                    padding: const EdgeInsets.all(16),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
