import 'package:flutter/material.dart';
import 'package:freecodecamp/models/news/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-article-post/news_article_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsArticlePostHeader extends StatefulWidget {
  const NewsArticlePostHeader({Key? key, required this.article})
      : super(key: key);

  final Article article;

  @override
  State<StatefulWidget> createState() => _NewsArticlePostHeaderState();
}

class _NewsArticlePostHeaderState extends State<NewsArticlePostHeader> {
  @override
  Widget build(BuildContext context) {
    var article = widget.article;
    return Column(
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/freecodecamp-banner.png',
                image: article.featureImage,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    launch(article.url as String);
                  },
                  icon: const Icon(Icons.open_in_new_sharp),
                  label: const Text('open in browser'),
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF0a0a23)),
                ),
              ),
            )
          ],
        ),
        Container(
          color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: const TextStyle(fontSize: 24),
                key: const Key('title'),
              ),
              ListTile(
                // ignore: unnecessary_null_comparison
                leading: article.profileImage == null
                    ? Image.asset(
                        'assets/images/placeholder-profile-img.png',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        article.profileImage,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                title: Text(
                  'Written by ' + article.authorName,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  NewsArticlePostViewModel.goToAuthorProfile(
                      article.authorSlug);
                },
                contentPadding: const EdgeInsets.only(top: 16, bottom: 8),
              ),
              Row(
                children: [
                  Expanded(child: NewsBookmarkViewWidget(article: article)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
