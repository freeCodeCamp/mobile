import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class CategoryList {
  late List<dynamic>? categories;
  late bool? canCreateTopic;
  late bool? canCreateCategory;

  CategoryList({this.categories, this.canCreateTopic, this.canCreateCategory});

  factory CategoryList.returnCategories(Map<String, dynamic> data) {
    return CategoryList(categories: data["category_list"]["categories"]);
  }

  factory CategoryList.canEditCategory(Map<String, dynamic> data) {
    return CategoryList(
        canCreateCategory: data["category_list"]["can_create_category"]);
  }

  factory CategoryList.canEditTopic(Map<String, dynamic> data) {
    return CategoryList(
        canCreateTopic: data["category_list"]["can_create_topic"]);
  }

  CategoryList.error() {
    throw Exception('Categories could not be loaded!');
  }
}
