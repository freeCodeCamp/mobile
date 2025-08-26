import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_notification_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

const forumLocation = 'https://forum.freecodecamp.org';

class LearnService {
  static final LearnService _learnService = LearnService._internal();
  final _authenticationService = locator<AuthenticationService>();

  final Dio _dio = DioService.dio;

  // TODO: change this to v2 and remove baseUrlV2 once the migration is complete
  static final baseUrl = '${AuthenticationService.baseURL}/curriculum-data/v1';
  static final baseUrlV2 =
      '${AuthenticationService.baseURL}/curriculum-data/v2';

  final LearnOfflineService learnOfflineService =
      locator<LearnOfflineService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final DailyChallengeService _dailyChallengeService =
      locator<DailyChallengeService>();
  final DailyChallengeNotificationService _notificationService =
      locator<DailyChallengeNotificationService>();

  factory LearnService() {
    return _learnService;
  }

  void setLastVisitedChallenge(String url, Block block) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('lastVisitedChallenge', [
      url,
      block.superBlock.dashedName,
      block.superBlock.name,
      block.dashedName,
    ]);
  }

  Future<void> postChallengeCompleted(
    Challenge challenge, {
    List? challengeFiles,
    String? solutionLink,
  }) async {
    String challengeId = challenge.id;
    ChallengeType challengeType = challenge.challengeType;

    Response submitTypesRes = await _dio.get('$baseUrlV2/submit-types.json');
    Map<String, dynamic> submitTypes = submitTypesRes.data;

    switch (submitTypes[challengeType.index.toString()]) {
      case 'tests':
        late Map payload;
        if (challengeType == ChallengeType.multifileCertProject ||
            challenge.block ==
                'javascript-algorithms-and-data-structures-projects') {
          payload = {
            'id': challengeId,
            'challengeType': challengeType.index,
            'files': challengeFiles,
          };
        } else {
          payload = {
            'id': challengeId,
            'challengeType': challengeType.index,
          };
        }
        Response res = await _dio.post(
          '${AuthenticationService.baseApiURL}/modern-challenge-completed',
          data: payload,
          options: Options(
            headers: {
              'CSRF-Token': _authenticationService.csrfToken,
              'Cookie':
                  'jwt_access_token=${_authenticationService.jwtAccessToken}; _csrf=${_authenticationService.csrf};',
            },
          ),
        );
        log(res.toString());
        break;
      case 'backend':
        break;
      case 'project.backEnd':
        Map payload = {
          'id': challengeId,
          'challengeType': challengeType.index,
          'solution': solutionLink
        };
        Response res = await _dio.post(
          '${AuthenticationService.baseApiURL}/project-completed',
          data: payload,
          options: Options(
            headers: {
              'CSRF-Token': _authenticationService.csrfToken,
              'Cookie':
                  'jwt_access_token=${_authenticationService.jwtAccessToken}; _csrf=${_authenticationService.csrf};',
            },
          ),
        );
        log(res.toString());
        break;
      case 'project.frontEnd':
        break;
    }
    await _authenticationService.fetchUser();
  }

  void passChallenge(
    Challenge challenge,
    String? solutionLink,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List challengeFiles = challenge.files.map((file) {
      return {
        'contents':
            prefs.getString('${challenge.id}.${file.name}.${file.ext.value}') ??
                file.contents,
        'ext': file.ext.name,
        'history': file.history,
        'key': file.fileKey,
        'name': file.name,
      };
    }).toList();

    await postChallengeCompleted(
      challenge,
      challengeFiles: challengeFiles,
      solutionLink: solutionLink,
    );
  }

  void passDailyChallenge(Challenge challenge) async {
    await _dailyChallengeService.postChallengeCompleted(
        challengeId: challenge.id,
        language: challenge.challengeType == 28
            ? DailyChallengeLanguage.javascript
            : DailyChallengeLanguage.python);

    await _authenticationService.fetchUser();

    // Refresh notifications if today's challenge was completed
    try {
      final todayChallenge = await _dailyChallengeService.fetchTodayChallenge();

      if (challenge.id == todayChallenge.id) {
        await _notificationService.scheduleDailyChallengeNotification();
      }
    } catch (e) {
      log('Failed to check today\'s challenge for notification update: $e');
    }
  }

  void goToNextChallenge(
    int maxChallenges,
    Challenge challenge,
    Block block, {
    String solutionLink = '',
  }) async {
    if (AuthenticationService.staticIsloggedIn) {
      if (challenge.challengeType == 28 || challenge.challengeType == 29) {
        passDailyChallenge(challenge);
        _navigationService.back();
        return;
      } else {
        passChallenge(challenge, solutionLink);
      }
    }

    var challengeIndex = block.challengeTiles.indexWhere(
      (element) => element.id == challenge.id,
    );
    if (challengeIndex == maxChallenges - 1) {
      _navigationService.back();
    } else {
      _navigationService.replaceWith(
        Routes.challengeTemplateView,
        arguments: ChallengeTemplateViewArguments(
          challengeId: block.challengeTiles[challengeIndex + 1].id,
          block: block,
        ),
      );
    }
  }

  Future<String> genForumLink(
    Challenge challenge,
    Block block,
    String description,
    BuildContext context, {
    String editorText = '',
  }) async {
    Challenge? currChallenge = challenge;

    final HelpCategory helpCategory = challenge.helpCategory;
    final String blockTitle = block.name;

    final userDeviceInfo = await getDeviceInfo(context);

    final titleText = '$blockTitle - ${currChallenge.title}';
    final String endingText =
        '**Your mobile information:**\n```txt\n$userDeviceInfo\n```\n\n**Challenge:** $titleText\n\n**Link to the challenge:**\nhttps://www.freecodecamp.org/learn/${currChallenge.superBlock}/${currChallenge.block}/${currChallenge.dashedName}';

    final String userCode = await filesToMarkdown(currChallenge, editorText);

    final String textMessage =
        "**Tell us what's happening:**\nDescribe your issue in detail here. \n\n$description \n\n**Your code so far**$userCode\n\n$endingText";
    final String altTextMessage =
        "**Tell us what's happening:**\n\n\n\n**Your code so far**\n\nWARNING\n\nThe challenge seed code and/or your solution exceeded the maximum length we can port over from the challenge.\n\nYou will need to take an additional step here so the code you wrote presents in an easy to read format.\n\nPlease copy/paste all the editor code showing in the challenge from where you just linked.\n\n```\nReplace these two sentences with your copied code.\nPlease leave the ``` line above and the ``` line below,\nbecause they allow your code to properly format in the post.\n\n```\n$endingText";

    String studentCode = Uri.encodeComponent(textMessage);
    String altStudentCode = Uri.encodeComponent(altTextMessage);

    final String baseURL =
        '$forumLocation/new-topic?category=${helpCategory.value}&title=$titleText&body=';
    final String defaultURL = '$baseURL$studentCode';
    final String altURL = '$baseURL$altStudentCode';

    return defaultURL.length < 8000 ? defaultURL : altURL;
  }

  Future forumHelpDialog(
    Challenge challenge,
    Block block,
    BuildContext context,
  ) async {
    DialogResponse? res = await _dialogService.showCustomDialog(
        barrierDismissible: true,
        variant: DialogType.askForHelp,
        title: 'Ask for Help',
        description:
            "If you've already tried the Read-Search-Ask method, then you can try asking for help on the freeCodeCamp forum.",
        mainButtonTitle: 'Create a post',
        data: {'challengeName': challenge.title, 'blockName': block.name});
    if (res != null && res.confirmed) {
      DialogResponse? forumRes = await _dialogService.showCustomDialog(
        variant: DialogType.askForHelpInput,
        title: 'Create a post',
        description:
            'You must confirm the following statements before you can submit your post to the forum.',
        mainButtonTitle: 'Submit',
        secondaryButtonTitle: 'Cancel',
        data: {'challengeName': challenge.title, 'blockName': block.name},
      );

      String description = forumRes?.data ?? '';

      if (forumRes != null && forumRes.confirmed) {
        try {
          final forumLink = await genForumLink(
            challenge,
            block,
            description,
            context,
          );

          await launchUrl(Uri.parse(forumLink));
        } catch (e) {
          log('Error launching forum link: $e');
        }
      }
    }
  }

  LearnService._internal();
}
