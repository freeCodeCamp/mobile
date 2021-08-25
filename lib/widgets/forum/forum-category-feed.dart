import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freecodecamp/widgets/forum/forum-post-feed.dart';
import 'package:hexcolor/hexcolor.dart';

import '/models/category-model.dart';
import 'forum-connect.dart';

class ForumCategoryView extends StatefulWidget {
  _ForumCategoryViewState createState() => _ForumCategoryViewState();
}

class _ForumCategoryViewState extends State<ForumCategoryView> {
  late Future<List<dynamic>?> categoryFuture;

  void initState() {
    super.initState();
    categoryFuture = fetchList();
  }

  Future<List<dynamic>?> fetchList() async {
    final response = await ForumConnect.connectAndGet('/categories');

    if (response.statusCode == 200) {
      return CategoryList.returnCategories(jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
        body: FutureBuilder<List<dynamic>?>(
          future: categoryFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var categories = snapshot.data;
              return ListView.builder(
                  itemCount: snapshot.data?.length,
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

  final List? categories;

  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ForumPostFeed(
                      id: categories?[index]["id"],
                      slug: categories?[index]["slug"],
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    width: 5,
                    color: HexColor(
                      "#" + categories?[index]["color"],
                    )))),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(categories?[index]["name"],
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    categories?[index]["description"],
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
                      categories![index]["topics_week"].toString() +
                          ' new topics this week',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w300)),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
