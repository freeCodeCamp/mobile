import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/core/navigation/app_navigator.dart';
import 'package:freecodecamp/core/navigation/app_snackbar.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
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
import 'package:freecodecamp/ui/views/learn/utils/learn_globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearnLandingViewModel extends ChangeNotifier {
  late final AuthenticationService _auth;
  AuthenticationService get auth => _auth;

  late final LearnService _learnService;
  LearnService get learnService => _learnService;

  late final LearnOfflineService _learnOfflineService;
  LearnOfflineService get learnOfflineService => _learnOfflineService;

  late final DailyChallengeService _dailyChallengeService;

  Future<List<Widget>>? superBlockButtons;
  final _dio = DioService.dio;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isBusy = false;
  bool get isBusy => _isBusy;

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

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void init(BuildContext context, WidgetRef ref) {
    _auth = ref.read(authenticationServiceProvider);
    _learnService = ref.read(learnServiceProvider);
    _learnOfflineService = ref.read(learnOfflineServiceProvider);
    _dailyChallengeService = ref.read(dailyChallengeServiceProvider);

    retrieveNewQuote();
    initLoggedInListener();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _setBusy(true);

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
      _setBusy(false);
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

        AppNavigator.navigateTo(
          Routes.superBlockView,
          arguments: SuperBlockViewArguments(
            superBlockDashedName: lastVisitedChallenge[1],
            superBlockName: lastVisitedChallenge[2],
            hasInternet: true,
          ),
        );

        AppNavigator.navigateTo(
          Routes.challengeTemplateView,
          arguments: ChallengeTemplateViewArguments(
            block: block,
            challengeId: challenge.id,
          ),
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
    _auth.isLoggedIn.listen((e) async {
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
    AppSnackbar.show(title: 'Not available use the web version', message: '');
  }

  Future<List<Widget>> requestSuperBlocks() async {
    String baseUrl = LearnService.baseUrl;

    TextStyle headerStyle = TextStyle(fontSize: 21);

    final Response res = await _dio.get('$baseUrl/available-superblocks.json');
    if (res.statusCode == 200) {
      await dotenv.load(fileName: '.env');

      bool showAllSB =
          dotenv.get('SHOWALLSB', fallback: 'false').toLowerCase() == 'true';

      Map<String, dynamic> superBlockStages = res.data['superblocks'];

      Map<String, String> stageOrder = {
        'core': 'Recommended curriculum (still in beta):',
        'english': 'Learn English for Developers:',
        'spanish': 'Learn Professional Spanish:',
        'chinese': 'Learn Professional Chinese:',
        'extra': 'Prepare for the developer interview job search:',
        'professional': 'Professional certifications:',
      };

      List<Widget> widgetOrder = [];

      for (var stage in stageOrder.keys) {
        if (superBlockStages.containsKey(stage)) {
          List stageBlocks = superBlockStages[stage];

          widgetOrder.add(
            Text(
              stageOrder[stage] ?? '',
              style: headerStyle,
            ),
          );

          for (var superBlock in stageBlocks) {
            if (superBlock['dashedName'].toString().contains('full-stack')) {
              continue;
            }

            Widget button = SuperBlockButton(
              button: SuperBlockButtonData(
                path: superBlock['dashedName'],
                name: superBlock['title'],
                public: !showAllSB ? superBlock['public'] : true,
              ),
              model: this,
            );

            widgetOrder.add(button);
          }
        }
      }

      return widgetOrder;
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
    if (chapterBasedSuperBlocks.contains(dashedName)) {
      AppNavigator.navigateTo(
        Routes.chapterView,
        arguments: ChapterViewArguments(
          superBlockDashedName: dashedName,
          superBlockName: name,
        ),
      );
    } else {
      AppNavigator.navigateTo(
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
    AppNavigator.pop();
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

final learnLandingViewModelProvider =
    ChangeNotifierProvider.autoDispose<LearnLandingViewModel>(
  (ref) => LearnLandingViewModel(),
);
