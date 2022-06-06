import 'package:flutter/material.dart';
import 'package:freecodecamp/models/news/article_model.dart';

class NewsArticleHeader extends StatelessWidget {
  const NewsArticleHeader({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              article.featureImage,
              fit: BoxFit.cover,
            )),
        Row(
          children: [
            Expanded(
              child: Container(
                color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                          fontSize: 24, height: 1.5, fontFamily: 'Lato'),
                      key: const Key('title'),
                    ),
                    Text(
                      'Written by ${article.authorName}',
                      style: const TextStyle(height: 1.5, fontFamily: 'Lato'),
                    ),
                    Wrap(
                      children: [
                        for (int j = 0;
                            j < article.tagNames.length && j < 3;
                            j++)
                          article.tagNames[j]
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
