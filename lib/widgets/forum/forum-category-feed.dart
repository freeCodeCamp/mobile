import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';

import '/models/category-model.dart';
import 'forum-connect.dart';

class ForumCategoryView extends StatefulWidget {
  _ForumCategoryViewState createState() => _ForumCategoryViewState();
}

class _ForumCategoryViewState extends State<ForumCategoryView> {
  List categories = [];

  late Future<dynamic> categoryFuture;

  void initState() {
    super.initState();
    categoryFuture = fetchList();
  }

  Future<dynamic> fetchList() async {
    final response = await ForumConnect.connectAndGet('/categories');

    if (response.statusCode == 200) {
      dev.log(response.toString());
      var decodedCategoryList =
          json.decode(response.body)['category_list']['categories'];
      categories.addAll(decodedCategoryList);
      return CategoryList.returnCategories(jsonDecode(response.body));
    } else {
      return Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<dynamic>(
      future: categoryFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dev.log(categories.length.toString());
          return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(categories[index]["name"])),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text(categories[index]["description"]))
                      ],
                    )
                  ],
                );
              });
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Center(child: const CircularProgressIndicator());
      },
    ));
  }
}
