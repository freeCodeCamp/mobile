import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/widgets/hint/hint_widget_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class HintWidgetView extends StatelessWidget {
  const HintWidgetView(
      {Key? key, required this.hint, required this.challengeModel})
      : super(key: key);

  final String hint;
  final ChallengeModel challengeModel;

  final forumLocation = 'https://forum.freecodecamp.org';

  String filesToMarkdown(List<ChallengeFile> challengeFiles) {
    // Currently this function has been done for single files
    // When working on multiple files, it's better if we keep a copy of the challengeFiles list and store user code there.
    final bool moreThanOneFile = challengeFiles.length > 1;
    String markdownStr = '\n';

    for (var challengeFile in challengeFiles) {
      final fileName = moreThanOneFile
          ? '/* file: ${challengeFile.name}.${challengeFile.ext} */\n'
          : '';
      final fileType = challengeFile.ext.value;
      markdownStr +=
          '```$fileType\n$fileName${challengeModel.editorText}\n```\n\n';
    }

    return markdownStr;
  }

  Future<String> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      return '${deviceInfo.model} - Android ${deviceInfo.version.release} - Android SDK ${deviceInfo.version.sdkInt} - Security Patch ${deviceInfo.version.securityPatch} - ${deviceInfo.fingerprint}';
    } else if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      return '${deviceInfo.model} - ${deviceInfo.systemName}${deviceInfo.systemVersion} - ${deviceInfo.identifierForVendor}';
    } else {
      return 'Unrecognized device';
    }
  }

  Future<String> genForumLink() async {
    Challenge? currChallenge = await challengeModel.challenge;
    String blockTitlePath = 'assets/learn/block-title.json';
    String blockTitleFile = await rootBundle.loadString(blockTitlePath);
    String helpCategoryPath = 'assets/learn/help-category.json';
    String helpCategoryFile = await rootBundle.loadString(helpCategoryPath);

    final String helpCategory = Uri.encodeComponent(
        jsonDecode(helpCategoryFile)[currChallenge?.block] ?? 'Help');
    final String blockTitle =
        jsonDecode(blockTitleFile)[currChallenge?.superBlock]
                [currChallenge?.block] ??
            '';

    final userDeviceInfo = await getDeviceInfo();

    final titleText = '$blockTitle - ${currChallenge?.title}';
    final String endingText =
        '**Your mobile information:**\n```txt\n$userDeviceInfo\n```\n\n**Challenge:** $titleText\n\n**Link to the challenge:**\nhttps://www.freecodecamp.org${currChallenge?.slug}';

    final String userCode = filesToMarkdown(currChallenge!.files);

    final String textMessage =
        "**Tell us what's happening:**\nDescribe your issue in detail here.\n\n**Your code so far**$userCode\n\n$endingText";
    final String altTextMessage =
        "**Tell us what's happening:**\n\n\n\n**Your code so far**\n\nWARNING\n\nThe challenge seed code and/or your solution exceeded the maximum length we can port over from the challenge.\n\nYou will need to take an additional step here so the code you wrote presents in an easy to read format.\n\nPlease copy/paste all the editor code showing in the challenge from where you just linked.\n\n```\nReplace these two sentences with your copied code.\nPlease leave the ``` line above and the ``` line below,\nbecause they allow your code to properly format in the post.\n\n```\n$endingText";

    String studentCode = Uri.encodeComponent(textMessage);
    String altStudentCode = Uri.encodeComponent(altTextMessage);

    final String baseURL =
        '$forumLocation/new-topic?category=$helpCategory&title=$titleText&body=';
    final String defaultURL = '$baseURL$studentCode';
    final String altURL = '$baseURL$altStudentCode';

    return defaultURL.length < 8000 ? defaultURL : altURL;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HintWidgetModel>.reactive(
        viewModelBuilder: () => HintWidgetModel(),
        builder: (context, model, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 28, horizontal: 16),
                      child: Text(
                        'Hint',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
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
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                        child: HtmlHandler.htmlWidgetBuilder(hint, context))
                  ],
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final forumLink = await genForumLink();
                          challengeModel.forumHelpDialog(forumLink);
                        },
                        icon: const Icon(Icons.question_mark),
                        padding: const EdgeInsets.all(16),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.restart_alt),
                        padding: const EdgeInsets.all(16),
                      ),
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
            ));
  }
}
