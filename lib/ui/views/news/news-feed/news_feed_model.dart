import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';

class Article {
  final String id;
  final String title;
  final String featureImage;
  final String profileImage;
  final String authorName;
  final String tagName;

  Article(
      {required this.id,
      required this.featureImage,
      required this.title,
      required this.profileImage,
      required this.authorName,
      required this.tagName});

  factory Article.fromJson(Map<String, dynamic> data) {
    return Article(
        featureImage: data["feature_image"],
        title: data["title"],
        profileImage: data['authors'][0]['profile_image'],
        authorName: data['authors'][0]['name'],
        tagName:
            data['tags'].length > 0 ? data['tags'][0]['name'] : 'FreeCodeCamp',
        id: data["id"]);
  }
}

class NewsFeedModel extends BaseViewModel {
  int _pageNumber = 0;
  final List<Article> articles = [];
  static const int itemRequestThreshold = 14;
  void initState() async {
    await fetchArticles(_pageNumber);
    notifyListeners();
  }

  Future<List<Article>> fetchArticles(pageNumber) async {
    await dotenv.load(fileName: ".env");
    String page = '&page=' + pageNumber.toString();
    String par = "&fields=title,url,feature_image,id&include=tags,authors";
    String url = "${dotenv.env['NEWSURL']}${dotenv.env['NEWSKEY']}$page$par";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var articleJson = json.decode(response.body)['posts'];

      for (int i = 0; i < articleJson?.length; i++) {
        articles.add(Article.fromJson(articleJson[i]));
      }
      return articles;
    } else {
      throw Exception(response.body);
    }
  }

  Future handleArticleLazyLoading(int index) async {
    var itemPosition = index + 1;
    var request = itemPosition % itemRequestThreshold == 0;
    var pageToRequest = itemPosition ~/ itemRequestThreshold;

    if (request && pageToRequest > _pageNumber) {
      _pageNumber = pageToRequest;
      await fetchArticles(_pageNumber);
      notifyListeners();
    }
  }

  String truncateStr(str) {
    if (str.length < 55) {
      return str;
    } else {
      return str.toString().substring(0, 55) + '...';
    }
  }

  Color randomBorderColor() {
    final random = Random();

    List borderColor = [
      const Color.fromRGBO(0x99, 0xC9, 0xFF, 1),
      const Color.fromRGBO(0xAC, 0xD1, 0x57, 1),
      const Color.fromRGBO(0xFF, 0xFF, 0x00, 1),
      const Color.fromRGBO(0x80, 0x00, 0x80, 1),
    ];

    int index = random.nextInt(borderColor.length);

    return borderColor[index];
  }

  String getArticleImage(imgUrl, context) {
    // Split the url
    List arr = imgUrl.toString().split('images');

    // Get the last index of the arr which is the name

    if (arr.length == 1) return imgUrl;

    double screenSize = MediaQuery.of(context).size.width;
    if (screenSize >= 600) {
      imgUrl = arr[0] + 'images/size/w1000' + arr[1];
    } else if (screenSize >= 300) {
      imgUrl = arr[0] + 'images/size/w600' + arr[1];
    } else if (screenSize >= 150) {
      imgUrl = arr[0] + 'images/size/w300' + arr[1];
    } else {
      imgUrl = arr[0] + 'images/size/w100' + arr[1];
    }

    return imgUrl;
  }

  String getProfileImage(imgUrl) {
    List arr = imgUrl.toString().split('images');

    if (arr.length == 1) return imgUrl;

    return arr[0] + 'images/size/w60' + arr[1];
  }
}
