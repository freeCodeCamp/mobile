import 'dart:convert';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/forum_category_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:developer' as dev;
import '../forum_connect.dart';

class ForumCategoryViewModel extends BaseViewModel {
  late Future<List<Category>> _future;
  Future<List<Category>> get future => _future;

  final NavigationService _navigationService = locator<NavigationService>();

  int _index = 1;
  int get index => _index;

  void onTapped(tapped) {
    _index = tapped;
    notifyListeners();
  }

  void initState() {
    _future = fetchCategories();
  }

  void goToPosts(slug, id) {
    id = id.toString();
    _navigationService.navigateTo(Routes.forumPostFeedView,
        arguments: ForumPostFeedViewArguments(slug: slug, id: id));
  }

  static Future<List<Category>> fetchCategories() async {
    final response = await ForumConnect.connectAndGet('/categories');

    List<Category> categories = [];

    List categoriesResponse =
        jsonDecode(response.body)['category_list']['categories'];
    if (response.statusCode == 200) {
      for (int i = 0; i < categoriesResponse.length; i++) {
        categories.add(Category.fromJson(categoriesResponse[i]));
      }
    }
    return categories;
  }
}
