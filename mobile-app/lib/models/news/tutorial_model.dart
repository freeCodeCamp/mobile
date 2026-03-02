import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/widgets/tag_widget.dart';

class Tutorial {
  final String id;
  final String slug;
  final String title;
  final String? featureImage;
  final String? profileImage;
  final String authorId;
  final String authorName;
  final String authorSlug;
  final String? createdAt;
  final List<Widget> tagNames;
  final List<dynamic> rawTags;
  final String? url;
  final String? text;

  Tutorial({
    required this.id,
    required this.slug,
    required this.featureImage,
    required this.title,
    required this.profileImage,
    required this.authorId,
    required this.authorName,
    required this.authorSlug,
    this.createdAt,
    this.tagNames = const [],
    this.rawTags = const [],
    this.url,
    this.text,
  });

  static List<Widget> returnTags(
    list, {
    bool compact = false,
  }) {
    List<Widget> tags = [];

    for (int i = 0; i < list.length; i++) {
      tags.add(TagButton(
        tagName: list[i]['name'],
        tagSlug: list[i]['slug'] ?? list[i]['id'],
        key: UniqueKey(),
        compact: compact,
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
      rawTags: data['tags'] ?? [],
      id: data['id'],
      slug: data['slug'],
    );
  }

  factory Tutorial.fromSearch(Map<String, dynamic> data) {
    return Tutorial(
      createdAt: data['publishedAt'],
      featureImage: data['featureImage'],
      title: data['title'],
      profileImage: data['author']['profileImage'],
      authorId: data['author']['id'],
      authorName: data['author']['name'],
      authorSlug: returnSlug(data['author']['url']),
      tagNames: returnTags(data['tags']),
      rawTags: data['tags'] ?? [],
      id: data['objectID'],
      slug: data['slug'],
    );
  }

  static String returnSlug(String url) {
    List splitUrl = url.split('/');

    return splitUrl[splitUrl.length - 2];
  }

  // this is factory is for the post view

  factory Tutorial.toPostFromJson(Map<String, dynamic> json) {
    return Tutorial(
      authorId: json['author']['id'],
      authorName: json['author']['name'],
      authorSlug: json['author']['username'],
      profileImage: json['author']['profilePicture'],
      tagNames: returnTags(json['tags']),
      rawTags: json['tags'] ?? [],
      id: json['id'],
      title: json['title'],
      url: json['url'],
      text: json['content']['html'],
      featureImage: json['coverImage']['url'],
      slug: json['slug'],
    );
  }
}

class Author {
  const Author({
    required this.slug,
    required this.id,
    required this.name,
    required this.profileImage,
    required this.bio,
    required this.website,
    required this.location,
    required this.facebook,
    required this.twitter,
  });

  final String slug;
  final String id;
  final String name;
  final String? profileImage;
  final String? bio;
  // TODO: Below items are not displayed in the UI. To be added
  final String? website;
  final String? location;
  final String? facebook;
  final String? twitter;

  factory Author.toAuthorFromJson(Map<String, dynamic> data) {
    return Author(
      slug: data['username'],
      id: data['id'],
      name: data['name'],
      profileImage: data['profilePicture'],
      bio: data['bio']['text'],
      website: data['socialMediaLinks']['website'],
      location: data['location'],
      facebook: data['socialMediaLinks']['facebook'],
      twitter: data['socialMediaLinks']['twitter'],
    );
  }
}
