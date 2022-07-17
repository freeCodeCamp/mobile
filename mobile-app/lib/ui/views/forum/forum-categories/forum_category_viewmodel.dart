import 'dart:convert' show jsonDecode;

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/forum/forum_category_model.dart';
import 'package:freecodecamp/models/forum/forum_user_model.dart';
import 'package:freecodecamp/ui/widgets/setup_dialog_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../forum_connect.dart';

class ForumCategoryViewModel extends BaseViewModel {
  late Future<List<Category>> _future;
  Future<List<Category>> get future => _future;

  late String _baseUrl;
  String get baseUrl => _baseUrl;

  final NavigationService _navigationService = locator<NavigationService>();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _userProfileIsLoading = true;
  bool get userProfileIsLoading => _userProfileIsLoading;

  late User _user;
  User get user => _user;

  int _index = 1;
  int get index => _index;

  void onTapped(tapped) {
    _index = tapped;
    notifyListeners();
  }

  void initState() async {
    _future = fetchCategories();
    _baseUrl = await ForumConnect.getCurrentUrl();
    notifyListeners();
  }

  void goToPosts(slug, id, name) {
    id = id.toString();
    _navigationService.navigateTo(Routes.forumPostFeedView,
        arguments: ForumPostFeedViewArguments(slug: slug, id: id, name: name));
  }

  void goToUserProfile() {
    _navigationService.navigateTo(Routes.forumUserProfileView);
  }

  Future<List<Category>> fetchCategories() async {
    final response = await ForumConnect.connectAndGet('/categories');

    List<Category> categories = [];

    List categoriesResponse =
        jsonDecode(response.body)['category_list']['categories'];
    if (response.statusCode == 200) {
      for (int i = 0; i < categoriesResponse.length; i++) {
        categories.add(Category.fromJson(categoriesResponse[i]));
      }
    }

    _isLoggedIn = await checkLoggedIn();
    _user = await fetchUser();
    notifyListeners();
    setupDialogUi();

    return categories;
  }

  Future<bool> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  Future<dynamic> fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? username;

    if (prefs.getString('username') != null) {
      username = prefs.getString('username');

      final response = await ForumConnect.connectAndGet('/u/$username');

      if (response.statusCode == 200) {
        _userProfileIsLoading = false;
        notifyListeners();
        return User.fromJson(jsonDecode(response.body));
      }
    } else {
      return null;
    }
  }
}
