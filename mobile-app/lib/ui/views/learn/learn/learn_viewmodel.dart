import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/models/learn/motivational_quote_model.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:freecodecamp/ui/widgets/setup_dialog_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class LearnViewModel extends BaseViewModel {
  WebViewController? controller;
  final NavigationService _navigationService = locator<NavigationService>();

  final AuthenticationService _auth = locator<AuthenticationService>();
  AuthenticationService get auth => _auth;

  final SnackbarService _snack = locator<SnackbarService>();
  SnackbarService get snack => _snack;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<List<SuperBlockButton>>? _superBlocks;
  Future<List<SuperBlockButton>>? get superBlocks => _superBlocks;

  void init(BuildContext context) {
    WebView.platform = SurfaceAndroidWebView();
    setupDialogUi();
    _superBlocks = getSuperBlocks();
    retrieveNewQuote();
    notifyListeners();
    initLoggedInListener();
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
    snack.showSnackbar(title: 'Not available', message: 'use the web version');
  }

  Future<List<SuperBlockButton>> getSuperBlocks() async {
    final http.Response res = await http.get(Uri.parse(
        'https://freecodecamp.dev/curriculum-data/v1/available-superblocks.json'));

    List<SuperBlockButton> buttonData = [];

    if (res.statusCode == 200) {
      List superBlocks = jsonDecode(res.body)['superblocks'];

      for (int i = 0; i < superBlocks.length; i++) {
        buttonData.add(SuperBlockButton(
            path: superBlocks[i]['dashedName'],
            name: superBlocks[i]['title'],
            public: true));
      }

      return buttonData;
    }
    return [];
  }

  Future<SuperBlock> getSuperBlockData(String superBlockName) async {
    final http.Response res = await http.get(Uri.parse(
        'https://freecodecamp.dev/curriculum-data/v1/$superBlockName.json'));

    if (res.statusCode == 200) {
      return SuperBlock.fromJson(jsonDecode(res.body));
    } else {
      throw Exception();
    }
  }

  void routeToSuperBlock(String superBlock) {
    _navigationService.navigateTo(Routes.superBlockView,
        arguments: SuperBlockViewArguments(superBlockName: superBlock));
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
