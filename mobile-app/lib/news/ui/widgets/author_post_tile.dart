import 'package:flutter/material.dart';
import 'package:freecodecamp/news/models/post_summary_model.dart';
import 'package:freecodecamp/routing/news.dart';
import 'package:jiffy/jiffy.dart';

class AuthorPostTile extends StatelessWidget {
  const AuthorPostTile({super.key, required this.post});

  final PostSummary post;

  @override
  Widget build(BuildContext context) {
    final published = DateTime.tryParse(post.publishedAt);
    return InkWell(
      onTap: () => NewsPostRoute(slug: post.slug).push(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 17,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (published != null) ...[
              const SizedBox(height: 8),
              Text(
                Jiffy.parseFromDateTime(
                  published.toLocal(),
                ).format(pattern: 'MMM d, yyyy'),
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
