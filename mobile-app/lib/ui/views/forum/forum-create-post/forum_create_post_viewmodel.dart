import 'dart:convert' show json, jsonDecode;

import 'package:flutter/cupertino.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/forum/forum_category_model.dart';
import 'package:freecodecamp/ui/views/forum/forum_connect.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForumCreatePostModel extends BaseViewModel {
  final _title = TextEditingController();
  final _code = TextEditingController();

  TextEditingController get title => _title;
  TextEditingController get code => _code;

  String _categoryDropdownValue = 'Category';
  String get categoryDropDownValue => _categoryDropdownValue;

  bool _topicHasError = false;
  bool get topicHasError => _topicHasError;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _categoryHasError = false;
  bool get categoryHasError => _categoryHasError;

  String _categoryError = '';
  String get categoryError => _categoryError;

  List<List<String>> categoryNamesWithIds = [];
  String selectedCategoryId = '0';

  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> createPost(String title, String text, [int? categoryId]) async {
    Map<String, String> headers = {
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final response = await ForumConnect.connectAndPost(
        '/posts.json?title=$title&raw=$text&category=$selectedCategoryId',
        headers);

    Map<String, dynamic> topic = json.decode(response.body);
    if (response.statusCode == 200) {
      _categoryHasError = false;

      if (!topic.containsKey('errors')) {
        goToPosts(topic['topic_slug'], topic['topic_id']);
      }
    } else {
      if (categoryDropDownValue == 'Category') {
        _categoryError = 'Please select a category!';
        _categoryHasError = true;
        notifyListeners();
      }

      _topicHasError = true;
      _errorMessage = topic['errors'][0];
      notifyListeners();
    }
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
    return categories;
  }

  Future<List<String>> requestCategorieNames() async {
    List<Category> categories = await fetchCategories();

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

    // this searches the name of the selected category, if the values are equal
    // the id gets selected e.g. [[390, JavaScript], [202, Python]]

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
