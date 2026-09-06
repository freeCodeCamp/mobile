import 'package:flutter/material.dart';

import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/news/ui/widgets/post_feed_list/post_feed_list.dart';

class NewsTagFeedView extends StatelessWidget {
  const NewsTagFeedView({super.key, required this.tagSlug, this.tagName});

  final String tagSlug;
  final String? tagName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tutorials about ${tagName ?? tagSlug}')),
      backgroundColor: FccColors.gray90,
      body: PostFeedList(tagSlug: tagSlug),
    );
  }
}
