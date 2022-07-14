import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/widgets/pass/pass_widget_model.dart';
import 'package:stacked/stacked.dart';

class PassWidgetView extends StatelessWidget {
  const PassWidgetView({Key? key, required this.challengeModel})
      : super(key: key);

  final ChallengeModel challengeModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PassWidgetModel>.reactive(
      viewModelBuilder: () => PassWidgetModel(),
      builder: (context, model, child) => Column(
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
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
                  MotivationalQuote quote = snapshot.data as MotivationalQuote;
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: LinearProgressIndicator(
              value: 0.35,
              minHeight: 7,
              backgroundColor: Color.fromRGBO(0x3B, 0x3B, 0x4F, 1),
            ),
          ),
          Expanded(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share_sharp),
                  padding: const EdgeInsets.all(16),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.remove_red_eye_outlined),
                  padding: const EdgeInsets.all(16),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
