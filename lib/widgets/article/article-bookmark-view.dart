import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookmarkViewTemplate extends StatefulWidget {
  BookmarkViewTemplate({Key? key}) : super(key: key);

  _BookmarkViewTemplateState createState() => _BookmarkViewTemplateState();
}

class _BookmarkViewTemplateState extends State<BookmarkViewTemplate> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('BOOKMARKED ARTICLES'),
            backgroundColor: Color(0xFF0a0a23)),
        backgroundColor: Color(0xFF0a0a23));
  }
}
