import 'package:flutter/cupertino.dart';
import 'package:freecodecamp/models/forum_category_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_viewmodel.dart';
import 'package:freecodecamp/ui/views/forum/forum_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class ForumCreatePostModel extends BaseViewModel {
  final _title = TextEditingController();
  final _code = TextEditingController();

  TextEditingController get title => _title;
  TextEditingController get code => _code;

  String _categoryDropdownValue = 'Category';
  String get categoryDropDownValue => _categoryDropdownValue;

  List<List<String>> categoryNamesWithIds = [];
  String selectedCategoryId = '0';

  Future<void> createPost(String title, String text, [int? categoryId]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      'X-Requested-With': 'XMLHttpRequest',
      "Content-Type": 'application/x-www-form-urlencoded'
    };

    ForumConnect.connectAndPost(
        '/posts.json?title=$title&raw=$text&category=$selectedCategoryId',
        headers);
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
}
