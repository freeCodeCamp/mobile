import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hexcolor/hexcolor.dart';

import '/models/category-model.dart';
import 'forum-connect.dart';

class ForumCategoryView extends StatefulWidget {
  _ForumCategoryViewState createState() => _ForumCategoryViewState();
}

class _ForumCategoryViewState extends State<ForumCategoryView> {
  List categories = [];

  late Future<CategoryList> categoryFuture;

  void initState() {
    super.initState();
    categoryFuture = fetchList();
  }

  Future<CategoryList> fetchList() async {
    final response = await ForumConnect.connectAndGet('/categories');

    if (response.statusCode == 200) {
      var decodedCategoryList =
          json.decode(response.body)['category_list']['categories'];
      categories.addAll(decodedCategoryList);
      return CategoryList.returnCategories(jsonDecode(response.body));
    }

    return CategoryList.error();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
        body: FutureBuilder<CategoryList>(
          future: categoryFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CategoryTemplate(
                        categories: categories, index: index);
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(child: const CircularProgressIndicator());
          },
        ));
  }
}

class CategoryTemplate extends StatelessWidget {
  CategoryTemplate({
    Key? key,
    required this.categories,
    required this.index,
  }) : super(key: key);

  final List categories;

  int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                  width: 5,
                  color: HexColor(
                    "#" + categories[index]["color"],
                  )))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(categories[index]["name"],
                    style: TextStyle(fontSize: 24, color: Colors.white)),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  categories[index]["description"],
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ))
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    categories[index]["topics_week"].toString() +
                        ' new topics this week',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
              ))
            ],
          )
        ],
      ),
    );
  }
}
