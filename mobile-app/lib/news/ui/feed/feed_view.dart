import 'package:flutter/material.dart';

import 'package:freecodecamp/news/controllers/feed_controller.dart';
import 'package:freecodecamp/news/ui/widgets/post_feed_list.dart';

class NewsFeedView extends StatelessWidget {
  const NewsFeedView({super.key});

  @override
  Widget build(BuildContext context) =>
      const PostFeedList(source: NewsFeedSource.all());
}
