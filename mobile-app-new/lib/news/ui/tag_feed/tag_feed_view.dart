import 'package:flutter/material.dart';
import 'package:mobile_app_new/news/controllers/feed_controller.dart';
import 'package:mobile_app_new/news/ui/widgets/post_feed_list.dart';
import 'package:mobile_app_new/widgets/app_bottom_navigation.dart';
import 'package:mobile_app_new/widgets/mini_player.dart';

class NewsTagFeedView extends StatelessWidget {
  const NewsTagFeedView({super.key, required this.tagSlug, this.tagName});

  final String tagSlug;
  final String? tagName;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('#${tagName ?? tagSlug}')),
    body: PostFeedList(source: NewsFeedSource.tag(tagSlug), featured: true),
    bottomNavigationBar: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MiniPlayer(),
        AppBottomNavigation(selected: AppDestination.tutorials),
      ],
    ),
  );
}
