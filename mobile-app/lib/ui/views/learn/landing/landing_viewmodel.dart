import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/landing/landing_view.dart';
import 'package:freecodecamp/ui/widgets/setup_dialog_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LearnLandingViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  final AuthenticationService _auth = locator<AuthenticationService>();
  AuthenticationService get auth => _auth;

  final LearnService _learnService = locator<LearnService>();
  LearnService get learnService => _learnService;

  final SnackbarService _snack = locator<SnackbarService>();
  SnackbarService get snack => _snack;

  final _learnOfflineService = locator<LearnOfflineService>();
  LearnOfflineService get learnOfflineService => _learnOfflineService;

  Future<List<Widget>>? superBlockButtons;
  final _dio = DioService.dio;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Color? _lastAvatarColor;

  TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  set setSuperBlockButtons(value) {
    superBlockButtons = value;
    notifyListeners();
  }

  void init(BuildContext context) async {
    setupDialogUi();
    retrieveNewQuote();
    initLoggedInListener();

    setSuperBlockButtons = requestSuperBlocks();
  }

  void fastRouteToChallenge() async {
    FccUserModel? user;

    int completedChallenges = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? lastVisitedChallenge = prefs.getStringList(
      'lastVisitedChallenge',
    );

    // Values
    // 0: full challenge url
    // 1: superblock dashed name
    // 2: superblock name
    // 3: block dashed name

    if (lastVisitedChallenge != null) {
      Challenge challenge = await learnOfflineService.getChallenge(
        lastVisitedChallenge[0],
      );

      String baseUrl = LearnService.baseUrlV2;

      final Response res =
          await _dio.get('$baseUrl/${lastVisitedChallenge[1]}.json');

      if (res.statusCode == 200) {
        List<Block> blocks = SuperBlock.fromJson(
          res.data,
          lastVisitedChallenge[1],
          lastVisitedChallenge[2],
        ).blocks as List<Block>;

        if (AuthenticationService.staticIsloggedIn) {
          user = await auth.userModel;
        }

        Block block = blocks.firstWhere(
          (element) => element.dashedName == lastVisitedChallenge[3],
        );

        Iterable<String> completedChallengeIds = user!.completedChallenges.map(
          (e) => e.id,
        );

        for (int i = 0; i < block.challenges.length; i++) {
          if (completedChallengeIds.contains(block.challenges[i].id)) {
            completedChallenges++;
          }
        }

        _navigationService.navigateToSuperBlockView(
          superBlockDashedName: lastVisitedChallenge[1],
          superBlockName: lastVisitedChallenge[2],
          hasInternet: true,
        );

        _navigationService.navigateToChallengeTemplateView(
          block: block,
          challengesCompleted: completedChallenges,
          challengeId: challenge.id,
        );
      }
    }
  }

  void refresh() async {
    setSuperBlockButtons = requestSuperBlocks();
    notifyListeners();
  }

  void initLoggedInListener() {
    _isLoggedIn = AuthenticationService.staticIsloggedIn;
    notifyListeners();
    auth.isLoggedIn.listen((e) {
      _isLoggedIn = e;
      notifyListeners();
    });
  }

  void disabledButtonSnack() {
    snack.showSnackbar(title: 'Not available use the web version', message: '');
    Future.delayed(const Duration(milliseconds: 2500), () {
      snack.closeSnackbar();
    });
  }

  Text handleStageTitle(String stage) {
    switch (stage) {
      case 'core':
        return Text(
          'Recommended curriculum (still in beta):',
          style: headerStyle,
        );
      case 'english':
        return Text(
          'Learn English for Developers:',
          style: headerStyle,
        );
      case 'extra':
        return Text(
          'Prepare for the developer interview job search:',
          style: headerStyle,
        );
      case 'legacy':
        return Text(
          'Our archived coursework:',
          style: headerStyle,
        );
      case 'professional':
        return Text(
          'Professional certifications:',
          style: headerStyle,
        );
    }

    return Text('');
  }

  Future<List<Widget>> requestSuperBlocks() async {
    String baseUrl = LearnService.baseUrlV2;

    final Response res = await _dio.get('$baseUrl/available-superblocks.json');

    List<Widget> layout = [];
    if (res.statusCode == 200) {
      Map<String, dynamic> superBlockStages = res.data['superblocks'];

      await dotenv.load(fileName: '.env');

      bool showAllSB =
          dotenv.get('SHOWALLSB', fallback: 'false').toLowerCase() == 'true';

      for (var superBlockStage in superBlockStages.keys) {
        layout.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: handleStageTitle(superBlockStage),
        ));

        for (var superBlock in superBlockStages[superBlockStage]) {
          layout.add(
            SuperBlockButton(
              button: SuperBlockButtonData(
                path: superBlock['dashedName'],
                name: superBlock['title'],
                public: !showAllSB ? superBlock['public'] : true,
              ),
              model: this,
            ),
          );
        }
      }

      return layout;
    }
    return [];
  }

  Color getRandomColor() {
    List colors = [
      FccColors.blue50,
      FccColors.green70,
      FccColors.yellow40,
      FccColors.red80,
      FccColors.purple50
    ];

    int random = Random().nextInt(colors.length);

    if (_lastAvatarColor == null) {
      _lastAvatarColor = colors[random];
      return getRandomColor();
    }

    if (_lastAvatarColor == colors[random]) {
      return getRandomColor();
    } else {
      _lastAvatarColor = colors[random];
    }

    return colors[random];
  }

  void routeToSuperBlock(String dashedName, String name) async {
    if (dashedName == 'full-stack-developer') {
      _navigationService.navigateTo(Routes.chapterView);
    } else {
      _navigationService.navigateTo(
        Routes.superBlockView,
        arguments: SuperBlockViewArguments(
          superBlockDashedName: dashedName,
          superBlockName: name,
          hasInternet: await learnOfflineService.hasInternet(),
        ),
      );
    }
  }

  void goBack() {
    _navigationService.back();
  }

  Future<MotivationalQuote> retrieveNewQuote() async {
    String path = 'assets/learn/motivational-quotes.json';
    String file = await rootBundle.loadString(path);

    int quoteLength = jsonDecode(file)['motivationalQuotes'].length;

    Random random = Random();

    int randomValue = random.nextInt(quoteLength);

    dynamic json = jsonDecode(file)['motivationalQuotes'][randomValue];

    MotivationalQuote quote = MotivationalQuote.fromJson(json);

    return quote;
  }
}
