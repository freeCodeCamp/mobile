import 'dart:convert';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/widgets/setup_dialog_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class LearnViewModel extends BaseViewModel {
  WebViewController? controller;
  final NavigationService _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  Future? _superBlocks;
  Future? get superBlocks => _superBlocks;

  void init() {
    WebView.platform = SurfaceAndroidWebView();
    setupDialogUi();
    isFirstTimeUsingLearn();
    _superBlocks = getSuperBlocks();
    notifyListeners();
  }

  void isFirstTimeUsingLearn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('isFirstTimeLearner') == null) {
      await showNewLearnerDialog();
    }
  }

  Future<void> showNewLearnerDialog() async {
    // ignore: unused_local_variable
    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.buttonForm2,
        title: 'This section is in alpha',
        description:
            'This section of the app is not complete, and you may experience bugs. You will not lose your progress as long as you\'re signed in',
        mainButtonTitle: 'I understand',
        data: DialogType.buttonForm2);

    if (response!.confirmed) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setBool('isFirstTimeLearner', false);
    }
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

  void initState(webViewController) {
    setWebViewController(webViewController);
    removeNavBar(webViewController);
  }

  void setWebViewController(WebViewController webViewController) {
    controller = webViewController;
    notifyListeners();
  }

  void removeNavBar(WebViewController? webViewController) {
    webViewController!.runJavascript(
        "document.getElementById('universal-nav').style.display = 'none'");
    webViewController.runJavascript(
        "document.getElementsByClassName('default-layout')[0].style.marginTop = 0;");
  }

  void goBack() {
    _navigationService.back();
  }
}
