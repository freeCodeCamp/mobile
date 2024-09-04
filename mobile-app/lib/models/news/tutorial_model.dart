import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/widgets/tag_widget.dart';

class Tutorial {
  final String id;
  final String title;
  final String? featureImage;
  final String? profileImage;
  final String? authorId;
  final String authorName;
  final String authorSlug;
  final String? createdAt;
  final List<Widget> tagNames;
  final String? url;
  final String? text;

  Tutorial({
    required this.id,
    required this.featureImage,
    required this.title,
    required this.profileImage,
    this.authorId,
    required this.authorName,
    required this.authorSlug,
    this.createdAt,
    this.tagNames = const [],
    this.url,
    this.text,
  });

  static List<Widget> returnTags(
    list,
  ) {
    List<Widget> tags = [];

    for (int i = 0; i < list.length; i++) {
      tags.add(TagButton(
        tagName: list[i]['name'],
        tagSlug: list[i]['slug'] ?? list[i]['id'],
        key: UniqueKey(),
      ));
    }
    return tags;
  }

  // this factory is for the endpoint where all tutorial thumbnails are received

  factory Tutorial.fromJson(dynamic data) {
    return Tutorial(
      createdAt: data['publishedAt'],
      featureImage: data['coverImage']['url'],
      title: data['title'],
      profileImage: data['author']['profilePicture'],
      authorId: data['author']['id'],
      authorName: data['author']['name'],
      authorSlug: data['author']['username'],
      tagNames: returnTags(data['tags']),
      id: data['id'],
    );
  }

  factory Tutorial.fromSearch(Map<String, dynamic> data) {
    return Tutorial(
        createdAt: data['publishedAt'],
        featureImage: data['featureImage'],
        title: data['title'],
        profileImage: data['author']['profileImage'],
        authorName: data['author']['name'],
        authorSlug: returnSlug(data['author']['url']),
        tagNames: returnTags(data['tags']),
        id: data['objectID']);
  }

  static String returnSlug(String url) {
    List splitUrl = url.split('/');

    return splitUrl[splitUrl.length - 2];
  }

  // this is factory is for the post view

  factory Tutorial.toPostFromJson(Map<String, dynamic> json) {
    return Tutorial(
      authorName: json['author']['name'],
      authorSlug: json['author']['username'],
      profileImage: json['author']['profilePicture'],
      tagNames: returnTags(json['tags']),
      id: json['id'],
      title: json['title'],
      url: json['url'],
      text: json['content']['html'],
      featureImage: json['coverImage']['url'],
    );
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
  final String? profileImage;
  final String? coverImage;
  final String? bio;
  final String? website;
  final String? location;
  final String? facebook;
  final String? twitter;
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
