import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/forum_category_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_viewmodel.dart';
import 'package:freecodecamp/ui/views/forum/forum_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForumCreatePostModel extends BaseViewModel {
  final _title = TextEditingController();
  final _code = TextEditingController();

  TextEditingController get title => _title;
  TextEditingController get code => _code;

  String _categoryDropdownValue = 'Category';
  String get categoryDropDownValue => _categoryDropdownValue;

  List<List<String>> categoryNamesWithIds = [];
  String selectedCategoryId = '0';

  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> createPost(String title, String text, [int? categoryId]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      'X-Requested-With': 'XMLHttpRequest',
      "Content-Type": 'application/x-www-form-urlencoded'
    };

    final response = await ForumConnect.connectAndPost(
        '/posts.json?title=$title&raw=$text&category=$selectedCategoryId',
        headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> post = jsonDecode(response.body);

      goToPosts(post["topic_slug"], post["topic_id"]);
    }
  }

  Future<List<String>> requestCategorieNames() async {
    List<Category> categories = await ForumCategoryViewModel.fetchCategories();

    List<String> categoryNames = [];

    categoryNames.add('Category');

    for (int i = 0; i < categories.length; i++) {
      categoryNames.add(categories[i].name);
      categoryNamesWithIds
          .add([categories[i].id.toString(), categories[i].name]);
    }
    return categoryNames;
  }

  void changeDropDownValue(value) {
    _categoryDropdownValue = value;
    notifyListeners();

    // set category id in parameter to the selected category
    for (int i = 0; i < categoryNamesWithIds.length; i++) {
      if (value == categoryNamesWithIds[i][1]) {
        selectedCategoryId = categoryNamesWithIds[i][0];
        notifyListeners();
      }
    }
  }

  void goToPosts(slug, id) {
    id = id.toString();
    _navigationService.navigateTo(Routes.forumPostView,
        arguments: ForumPostViewArguments(slug: slug, id: id));
  }
}
