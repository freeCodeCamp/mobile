import 'dart:convert';

import 'package:stacked/stacked.dart';

import '../forum_connect.dart';

class CategoryList {
  static List<dynamic> returnCategories(Map<String, dynamic> data) {
    return data["category_list"]["categories"];
  }

  static bool canEditCategory(Map<String, dynamic> data) {
    return data["category_list"]["can_create_category"];
  }

  static bool canEditTopic(Map<String, dynamic> data) {
    return data["category_list"]["can_create_topic"];
  }

  CategoryList.error() {
    throw Exception('Categories could not be loaded!');
  }
}

class ForumCategoryViewModel extends BaseViewModel {
  late Future<List<dynamic>?> _future;
  Future<List<dynamic>?> get future => _future;

  int _index = 1;
  int get index => _index;

  void onTapped(tapped) {
    _index = tapped;
  }

  void initState() {
    _future = fetchCategories();
  }

  Future<List<dynamic>?> fetchCategories() async {
    final response = await ForumConnect.connectAndGet('/categories');

    if (response.statusCode == 200) {
      return CategoryList.returnCategories(jsonDecode(response.body));
    }
  }
}
