import 'package:flutter/material.dart';
import 'package:freecodecamp/routing/news.dart';
import 'package:go_router/go_router.dart';

class NewsBackButton extends StatelessWidget {
  const NewsBackButton({super.key});

  @override
  Widget build(BuildContext context) => BackButton(
    onPressed: () {
      if (context.canPop()) {
        context.pop();
      } else {
        const NewsFeedRoute().go(context);
      }
    },
  );
}
