import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/widgets/tag_widget.dart';

class Article {
  final String id;
  final String title;
  final String featureImage;
  final String profileImage;
  final String authorName;
  final String authorSlug;
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
      required this.authorSlug,
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
        authorSlug: data['authors'][0]['slug'],
        tagNames: returnTags(data['tags']),
        id: data["id"]);
  }

  // this is factory is for the post view

  factory Article.toPostFromJson(Map<String, dynamic> json) {
    return Article(
        authorName: json['posts'][0]['primary_author']['name'],
        authorSlug: json['posts'][0]['primary_author']['slug'],
        profileImage: json['posts'][0]['primary_author']['profile_image'],
        id: json['posts'][0]['id'],
        title: json['posts'][0]['title'],
        url: json['posts'][0]['url'],
        text: json['posts'][0]['html'],
        featureImage: json['posts'][0]['feature_image']);
  }
}

class Author {
  const Author(
      {required this.slug,
      required this.id,
      required this.name,
      required this.profileImage,
      this.coverImage = '',
      required this.bio,
      required this.website,
      required this.location,
      required this.facebook,
      required this.twitter,
      this.metaTile = '',
      this.metaDescription = '',
      required this.url});

  final String slug;
  final String id;
  final String name;
  final String profileImage;
  final String? coverImage;
  final String? bio;
  final String website;
  final String? location;
  final String facebook;
  final String twitter;
  final String? metaTile;
  final String? metaDescription;
  final String url;

  factory Author.toAuthorFromJson(Map<String, dynamic> data) {
    return Author(
        slug: data['slug'],
        id: data['id'],
        name: data['name'],
        profileImage: data['profile_image'],
        bio: data['bio'],
        website: data['website'],
        location: data['location'],
        facebook: data['facebook'],
        twitter: data['twitter'],
        url: data['url']);
  }
}
