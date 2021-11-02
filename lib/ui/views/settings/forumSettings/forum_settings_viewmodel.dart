import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class ForumSettingsViewModel extends BaseViewModel {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void init() async {
    _isLoggedIn = await checkLoggedIn();
    notifyListeners();
  }

  void forumLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('loggedIn', false);
    prefs.remove('username');
    _isLoggedIn = false;
    notifyListeners();
  }

  void gotoForum() {
    launch('https://forum.freecodecamp.org/');
  }

  Future<bool> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }
}
