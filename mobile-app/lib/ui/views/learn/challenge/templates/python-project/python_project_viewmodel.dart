import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/learn/learn_service.dart';
import 'package:stacked/stacked.dart';

class PythonProjectViewModel extends BaseViewModel {
  final LearnService learnService = locator<LearnService>();

  TextEditingController linkController = TextEditingController();

  final fCCRegex = RegExp(
    r'codepen\.io\/freecodecamp|freecodecamp\.rocks|github\.com\/freecodecamp|\.freecodecamp\.org',
    caseSensitive: false,
  );
  final localhostRegex = RegExp(r'localhost:');
  final httpRegex = RegExp(r'http(?!s|([^s]+?localhost))');

  bool? _validLink;
  bool? get validLink => _validLink;

  String _linkErrMsg = '';
  String get linkErrMsg => _linkErrMsg;

  set setValidLink(bool? status) {
    _validLink = status;
    notifyListeners();
  }

  set setLinkErrMsg(String msg) {
    _linkErrMsg = msg;
    notifyListeners();
  }

  bool isUrl(String url) {
    return Uri.parse(url).isAbsolute;
  }

  void checkLink() {
    if (!isUrl(linkController.text)) {
      setValidLink = false;
      setLinkErrMsg = 'Please enter a valid link.';
      return;
    } else if (fCCRegex.hasMatch(linkController.text)) {
      setValidLink = false;
      setLinkErrMsg = 'Remember to submit your own work.';
      return;
    } else if (httpRegex.hasMatch(linkController.text)) {
      setValidLink = false;
      setLinkErrMsg = 'An unsecure (http) URL cannot be used.';
      return;
    } else if (localhostRegex.hasMatch(linkController.text)) {
      setValidLink = false;
      setLinkErrMsg = 'Remember to submit a publicly visible app URL.';
      return;
    } else {
      setValidLink = true;
    }
  }
}
