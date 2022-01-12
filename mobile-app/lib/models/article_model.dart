import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/widgets/tag_widget.dart';

class Article {
  final String id;
  final String title;
  final String featureImage;
  final String profileImage;
  final String authorName;
  final String? createdAt;
  final List<Widget> tagNames;
  final String? url;
  final String? text;

  Article(
      {required this.id,
      required this.featureImage,
      required this.title,
      required this.profileImage,
      required this.authorName,
      this.createdAt,
      this.tagNames = const [],
      this.url,
      this.text});

  static List<Widget> returnTags(
    list,
  ) {
    List<Widget> tags = [];

    for (int i = 0; i < list.length; i++) {
      tags.add(TagButton(
        tagName: list[i]['name'],
        tagSlug: list[i]['slug'],
        key: UniqueKey(),
      ));
    }
    return tags;
  }

  // this factory is for the endpoint where all article thumbnails are received

  factory Article.fromJson(Map<String, dynamic> data) {
    return Article(
        createdAt: data["published_at"],
        featureImage: data["feature_image"],
        title: data["title"],
        profileImage: data['authors'][0]['profile_image'],
        authorName: data['authors'][0]['name'],
        tagNames: returnTags(data['tags']),
        id: data["id"]);
  }

  // this is factory is for the post view

  factory Article.toPostFromJson(Map<String, dynamic> json) {
    return Article(
        authorName: json['posts'][0]['primary_author']['name'],
        profileImage: json['posts'][0]['primary_author']['profile_image'],
        id: json['posts'][0]['id'],
        title: json['posts'][0]['title'],
        url: json['posts'][0]['url'],
        text: json['posts'][0]['html'],
        featureImage: json['posts'][0]['feature_image']);
  }
}
