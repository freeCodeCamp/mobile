import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/news/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:developer' as dev;

import 'package:stacked_services/stacked_services.dart';

class ArticleList extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ArticleList({
    Key? key,
    required this.authorSlug,
    required this.authorName,
  }) : super(key: key);

  final String authorSlug;
  final String authorName;
  final _navigationService = locator<NavigationService>();
  Future<List<Article>> fetchList() async {
    List<Article> articles = [];

    await dotenv.load();

    String par =
        "&fields=title,url,feature_image,slug,published_at,id&include=tags,authors";
    String url =
        "${dotenv.env['NEWSURL']}posts/?key=${dotenv.env['NEWSKEY']}&page=1$par&filter=author:$authorSlug";

    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      dev.log(url);
      var articleJson = json.decode(response.body)['posts'];
      for (int i = 0; i < articleJson?.length; i++) {
        articles.add(Article.fromJson(articleJson[i]));
      }
      return articles;
    } else {
      throw Exception('Something when wrong when fetching $url');
    }
  }

  void navigateToArticle(String id) {
    _navigationService.navigateTo(Routes.newsArticlePostView,
        arguments: NewsArticlePostViewArguments(refId: id));
  }

  void navigateToFeed() {
    _navigationService.navigateTo(
      Routes.newsFeedView,
      arguments: NewsFeedViewArguments(
        author: authorSlug,
        fromAuthor: true,
        subject: authorName,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => ArticleListState();
}

class ArticleListState extends State<ArticleList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
        future: widget.fetchList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dev.log(snapshot.data!.length.toString());
            return Column(
              children: [
                Row(
                  children: [
                    TileLayout(
                      widget: widget,
                      snapshot: snapshot,
                    ),
                  ],
                ),
                snapshot.data!.length > 5
                    ? ListTile(
                        title: const Text("Show more articles"),
                        tileColor: const Color(0xFF0a0a23),
                        trailing: const Icon(Icons.arrow_forward_ios_outlined),
                        onTap: () {
                          widget.navigateToFeed();
                        },
                      )
                    : Container()
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class TileLayout extends StatelessWidget {
  const TileLayout({Key? key, required this.widget, required this.snapshot})
      : super(key: key);

  final ArticleList widget;
  final AsyncSnapshot<List<Article>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data!.length > 5 ? 5 : snapshot.data?.length,
          itemBuilder: (context, index) {
            Article article = snapshot.data![index];
            return ListTile(
              title: Text(
                article.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              tileColor: const Color(0xFF0a0a23),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              horizontalTitleGap: 10,
              subtitle: Text(
                NewsFeedModel.parseDate(article.createdAt),
                style: const TextStyle(height: 2),
              ),
              trailing: Image.network(
                article.featureImage,
              ),
              onTap: () {
                widget.navigateToArticle(article.id);
              },
            );
          }),
    );
  }
}
