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
import 'package:freecodecamp/models/learn/completed_challenge_model.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/daily_challenge_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/learn/daily_challenge_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
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

  final _dailyChallengeService = DailyChallengeService();

  Future<List<Widget>>? superBlockButtons;
  final _dio = DioService.dio;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  DailyChallenge? _dailyChallenge;
  DailyChallenge? get dailyChallenge => _dailyChallenge;

  bool _isDailyChallengeCompleted = false;
  bool get isDailyChallengeCompleted => _isDailyChallengeCompleted;

  TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  set setSuperBlockButtons(value) {
    superBlockButtons = value;
    notifyListeners();
  }

  set setDailyChallenge(DailyChallenge? value) {
    _dailyChallenge = value;
    notifyListeners();
  }

  set setIsDailyChallengeCompleted(bool value) {
    _isDailyChallengeCompleted = value;
    notifyListeners();
  }

  void init(BuildContext context) async {
    setupDialogUi();
    retrieveNewQuote();
    initLoggedInListener();

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setBusy(true);

    try {
      // Run both API calls in parallel, but handle failures independently
      final results = await Future.wait([
        requestSuperBlocks().catchError((e) => <Widget>[]),
        _fetchDailyChallenge().catchError((e) {
          setDailyChallenge = null;
          setIsDailyChallengeCompleted = false;
          return null;
        }),
      ]);

      setSuperBlockButtons = Future.value(results[0] as List<Widget>);
    } finally {
      setBusy(false);
    }
  }

  void fastRouteToChallenge() async {
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

      String baseUrl = LearnService.baseUrl;

      final Response res =
          await _dio.get('$baseUrl/${lastVisitedChallenge[1]}.json');

      if (res.statusCode == 200) {
        List<Block> blocks = SuperBlock.fromJson(
          res.data,
          lastVisitedChallenge[1],
          lastVisitedChallenge[2],
        ).blocks as List<Block>;

        Block block = blocks.firstWhere(
          (element) => element.dashedName == lastVisitedChallenge[3],
        );

        _navigationService.navigateToSuperBlockView(
          superBlockDashedName: lastVisitedChallenge[1],
          superBlockName: lastVisitedChallenge[2],
          hasInternet: true,
        );

        _navigationService.navigateToChallengeTemplateView(
          block: block,
          challengeId: challenge.id,
        );
      }
    }
  }

  void refresh() async {
    _loadInitialData();
  }

  void initLoggedInListener() {
    _isLoggedIn = AuthenticationService.staticIsloggedIn;
    notifyListeners();
    auth.isLoggedIn.listen((e) async {
      _isLoggedIn = e;
      await updateDailyChallengeCompletionStatus();
      notifyListeners();
    });
  }

  Future<void> updateDailyChallengeCompletionStatus() async {
    if (!_isLoggedIn) {
      setIsDailyChallengeCompleted = false;
    } else if (_dailyChallenge != null) {
      final isCompleted = await _checkIfChallengeCompleted(_dailyChallenge!.id);
      setIsDailyChallengeCompleted = isCompleted;
    }
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
    String baseUrl = LearnService.baseUrl;

    final Response res = await _dio.get('$baseUrl/available-superblocks.json');

    List<Widget> layout = [];
    if (res.statusCode == 200) {
      await dotenv.load(fileName: '.env');

      bool showAllSB =
          dotenv.get('SHOWALLSB', fallback: 'false').toLowerCase() == 'true';

      Map<String, dynamic> superBlockStages = res.data['superblocks'];

      List<String> stageOrder = [
        'legacy',
        'professional',
        'extra',
        'core',
        'english'
      ];

      List<Widget> publicButtons = [];
      List<Widget> nonPublicButtons = [];

      for (var stage in stageOrder) {
        if (superBlockStages.containsKey(stage)) {
          List stageBlocks = superBlockStages[stage];

          for (var superBlock in stageBlocks) {
            if (superBlock['dashedName'].toString().contains('full-stack')) {
              continue;
            }

            bool isPublic = superBlock['public'] ?? false;
            Widget button = SuperBlockButton(
              button: SuperBlockButtonData(
                path: superBlock['dashedName'],
                name: superBlock['title'],
                public: !showAllSB ? superBlock['public'] : true,
              ),
              model: this,
            );

            if (isPublic) {
              publicButtons.add(button);
            } else {
              nonPublicButtons.add(button);
            }
          }
        }
      }

      layout = [...publicButtons, ...nonPublicButtons];

      return layout;
    }
    return [];
  }

  Future<void> _fetchDailyChallenge() async {
    final todayChallenge = await _dailyChallengeService.fetchTodayChallenge();
    final isCompleted = await _checkIfChallengeCompleted(todayChallenge.id);

    setDailyChallenge = todayChallenge;
    setIsDailyChallengeCompleted = isCompleted;
  }

  Future<bool> _checkIfChallengeCompleted(String challengeId) async {
    FccUserModel? user = await _auth.userModel;
    if (user != null) {
      for (CompletedDailyChallenge challenge
          in user.completedDailyCodingChallenges) {
        if (challenge.id == challengeId) {
          return true;
        }
      }
    }
    return false;
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
