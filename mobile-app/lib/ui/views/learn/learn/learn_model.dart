import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/learn/learn_offline_service.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:freecodecamp/ui/widgets/setup_dialog_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;

class LearnViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  final AuthenticationService _auth = locator<AuthenticationService>();
  AuthenticationService get auth => _auth;

  final LearnService _learnService = locator<LearnService>();
  LearnService get learnService => _learnService;

  final SnackbarService _snack = locator<SnackbarService>();
  SnackbarService get snack => _snack;

  final LearnOfflineService _learnOfflineService =
      locator<LearnOfflineService>();
  LearnOfflineService get learnOfflineService => _learnOfflineService;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void init(BuildContext context) async {
    setupDialogUi();
    retrieveNewQuote();
    notifyListeners();
    initLoggedInListener();
  }

  Future<List<SuperBlockButton>> getSuperBlocks() async {
    return await _learnOfflineService.hasInternet()
        ? requestSuperBlocks()
        : _learnOfflineService.getCachedSuperblocks();
  }

  void refresh() async {
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
  }

  Future<List<SuperBlockButton>> requestSuperBlocks() async {
    String baseUrl = await _learnService.getBaseUrl();

    final http.Response res = await http.get(
      Uri.parse(
        '$baseUrl/curriculum-data/v1/available-superblocks.json',
      ),
    );

    List<SuperBlockButton> buttonData = [];

    if (res.statusCode == 200) {
      List superBlocks = jsonDecode(res.body)['superblocks'];

      await dotenv.load(fileName: '.env');

      bool showAllSB =
          dotenv.get('SHOWALLSB', fallback: 'false').toLowerCase() == 'true';

      for (int i = 0; i < superBlocks.length; i++) {
        buttonData.add(
          SuperBlockButton(
            path: superBlocks[i]['dashedName'],
            name: superBlocks[i]['title'],
            public: !showAllSB ? superBlocks[i]['public'] : true,
          ),
        );
      }

      return buttonData;
    }
    return [];
  }

  Future<SuperBlock> getSuperBlockData(
    String dashedName,
    String name,
    bool hasInternet,
  ) async {
    String baseUrl = await _learnService.getBaseUrl();

    if (!hasInternet) {
      return SuperBlock(
        dashedName: dashedName,
        name: name,
        blocks: await _learnOfflineService.getCachedBlocks(
          dashedName,
        ),
      );
    }

    final http.Response res = await http.get(
      Uri.parse(
        '$baseUrl/curriculum-data/v1/$dashedName.json',
      ),
    );

    if (res.statusCode == 200) {
      return SuperBlock.fromJson(
        jsonDecode(res.body),
        dashedName,
        name,
      );
    } else {
      throw Exception(e);
    }
  }

  void routeToSuperBlock(String dashedName, String name) async {
    _navigationService.navigateTo(
      Routes.superBlockView,
      arguments: SuperBlockViewArguments(
        superBlockDashedName: dashedName,
        superBlockName: name,
        hasInternet: await learnOfflineService.hasInternet(),
      ),
    );
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
