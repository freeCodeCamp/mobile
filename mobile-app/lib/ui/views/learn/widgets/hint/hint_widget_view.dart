import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/widgets/hint/hint_widget_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/utils/helpers.dart';
import 'package:phone_ide/phone_ide.dart';
import 'package:stacked/stacked.dart';

Future<String> genForumLink(
  Challenge challenge,
  Block block,
  BuildContext context, {
  String editorText = '',
}) async {
  Challenge? currChallenge = challenge;

  final HelpCategory helpCategory = challenge.helpCategory;
  final String blockTitle = block.name;

  final userDeviceInfo = await getDeviceInfo(context);

  final titleText = '$blockTitle - ${currChallenge.title}';
  final t = context.t;
  final String endingText =
      '**${t.forum_mobile_info}**\n```txt\n$userDeviceInfo\n```\n\n**${t.forum_challenge}** $titleText\n\n**${t.forum_challenge_link}**\nhttps://www.freecodecamp.org/learn/${currChallenge.superBlock}/${currChallenge.block}/${currChallenge.dashedName}';

  final String userCode = await filesToMarkdown(currChallenge, editorText);

  final String textMessage =
      '**${t.forum_tell_us_heading}**\n${t.forum_describe_issue}\n\n**${t.forum_code_so_far}**$userCode\n\n$endingText';
  final String altTextMessage =
      '**${t.forum_tell_us_heading}**\n\n\n\n**${t.forum_code_so_far}**\n\n${t.forum_warning}\n\n${t.forum_code_too_long}\n\n${t.forum_additional_step}\n\n${t.forum_copy_editor_code}\n\n```\n${t.forum_replace_code}\n\n```\n$endingText';

  String studentCode = Uri.encodeComponent(textMessage);
  String altStudentCode = Uri.encodeComponent(altTextMessage);

  final String baseURL =
      '$forumLocation/new-topic?category=${helpCategory.value}&title=$titleText&body=';
  final String defaultURL = '$baseURL$studentCode';
  final String altURL = '$baseURL$altStudentCode';

  return defaultURL.length < 8000 ? defaultURL : altURL;
}

class HintWidgetView extends StatelessWidget {
  const HintWidgetView(
      {super.key,
      required this.hint,
      required this.challengeModel,
      required this.editor});

  final String hint;
  final ChallengeViewModel challengeModel;

  final Editor editor;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder<HintWidgetModel>.reactive(
      viewModelBuilder: () => HintWidgetModel(),
      builder: (context, model, child) => SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    context.t.hint,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.87),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: parser.parse(hint),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        challengeModel.learnService.forumHelpDialog(
                          challengeModel.challenge as Challenge,
                          challengeModel.block as Block,
                          context,
                        );
                      },
                      icon: const Icon(Icons.question_mark),
                      padding: const EdgeInsets.all(16),
                    ),
                    IconButton(
                      onPressed: () {
                        challengeModel.resetCode(editor, context);
                      },
                      icon: const Icon(Icons.restart_alt),
                      padding: const EdgeInsets.all(16),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
