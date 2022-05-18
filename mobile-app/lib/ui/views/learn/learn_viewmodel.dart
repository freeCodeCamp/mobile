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

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final AuthenticationService _auth = locator<AuthenticationService>();
  AuthenticationService get auth => _auth;

  bool _isHeaderVisible = true;
  bool get isHeaderVisible => _isHeaderVisible;

  Future? _superBlocks;
  Future? get superBlocks => _superBlocks;

  void init(BuildContext context) {
    WebView.platform = SurfaceAndroidWebView();
    setupDialogUi();
    initScrollListener(context);
    _superBlocks = getSuperBlocks();
    retrieveNewQuote();
    notifyListeners();
  }

  void initScrollListener(BuildContext context) {
    _scrollController.addListener(() {
      double viewport = _scrollController.position.viewportDimension;
      double paddingHeaderText = 32;
      double headerStopsAt = (viewport - paddingHeaderText) * 0.25;

      double topOffset = scrollController.offset;

      if (topOffset > headerStopsAt) {
        // this prevents the notifylisteners to be called everytime on scroll
        if (_isHeaderVisible) {
          _isHeaderVisible = false;
          notifyListeners();
        }
      } else if (!_isHeaderVisible) {
        _isHeaderVisible = true;
        notifyListeners();
      }
    });
  }

  Future<void> getSuperBlocks() async {
    final http.Response res = await http.get(
        Uri.parse('https://freecodecamp.dev/mobile/availableSuperblocks.json'));

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['superblocks'];
    }
  }

  Future<SuperBlock> getSuperBlockData(String superBlockName) async {
    final http.Response res = await http
        .get(Uri.parse('https://freecodecamp.dev/mobile/$superBlockName.json'));

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

  String handleName(LearnViewModel model) {
    if (model.auth.userModel?.name != null) {
      return model.auth.userModel?.name as String;
    } else {
      return model.auth.userModel?.username as String;
    }
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
