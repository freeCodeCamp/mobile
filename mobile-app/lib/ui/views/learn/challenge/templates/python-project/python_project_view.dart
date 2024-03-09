import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/templates/python-project/python_project_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/dynamic_panel/panels/hint/hint_widget_view.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class PythonProjectView extends StatelessWidget {
  const PythonProjectView({
    Key? key,
    required this.challenge,
    required this.block,
    required this.challengesCompleted,
  }) : super(key: key);

  final Challenge challenge;
  final Block block;
  final int challengesCompleted;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder<PythonProjectViewModel>.reactive(
      viewModelBuilder: () => PythonProjectViewModel(),
      builder: (context, model, child) {
        return PopScope(
          canPop: true,
          onPopInvoked: (bool didPop) async {
            model.learnService.updateProgressOnPop(context, block);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(challenge.title),
            ),
            body: SafeArea(
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 48),
                children: [
                  ...parser.parse(challenge.description),
                  buildDivider(),
                  ...parser.parse(challenge.instructions),
                  buildDivider(),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      context.t.solution_link,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextFormField(
                      controller: model.linkController,
                      onChanged: (value) => model.setValidLink = null,
                      decoration: InputDecoration(
                        hintText: 'ex: https://replit.com/@camperbot/hello',
                        errorText: model.validLink != null && !model.validLink!
                            ? model.linkErrMsg
                            : null,
                        errorMaxLines: 5,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              model.validLink != null && model.validLink!
                                  ? const BorderSide(
                                      color: Colors.green,
                                    )
                                  : const BorderSide(
                                      color: Colors.white,
                                    ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              model.validLink != null && model.validLink!
                                  ? const BorderSide(
                                      color: Colors.green,
                                      width: 2,
                                    )
                                  : const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        backgroundColor: const Color.fromRGBO(
                          0x3b,
                          0x3b,
                          0x4f,
                          1,
                        ),
                        side: const BorderSide(
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: model.linkController.text.isEmpty
                          ? null
                          : () {
                              model.validLink != null && model.validLink!
                                  ? model.learnService.goToNextChallenge(
                                      block.challenges.length,
                                      challengesCompleted,
                                      challenge,
                                      block,
                                    )
                                  : model.checkLink();
                            },
                      child: Text(
                        model.validLink != null && model.validLink!
                            ? context.t.solution_link_submit
                            : context.t.solution_link_check,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        backgroundColor: const Color.fromRGBO(
                          0x3b,
                          0x3b,
                          0x4f,
                          1,
                        ),
                        side: const BorderSide(
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        final forumLink = await genForumLink(
                          challenge,
                          block,
                          context,
                        );
                        model.learnService.forumHelpDialog(forumLink);
                      },
                      child: Text(
                        context.t.ask_for_help,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
