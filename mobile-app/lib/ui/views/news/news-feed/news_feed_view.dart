import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/models/news/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_lazyloading.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_feed_viewmodel.dart';

class NewsFeedView extends StatelessWidget {
  const NewsFeedView(
      {Key? key,
      this.slug = '',
      this.author = '',
      this.fromAuthor = false,
      this.fromTag = false,
      this.subject = ''})
      : super(key: key);

  final String subject;
  final String slug;
  final String author;

  final bool fromTag;
  final bool fromAuthor;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsFeedModel>.reactive(
      viewModelBuilder: () => NewsFeedModel(),
      builder: (context, model, child) => Scaffold(
          appBar: fromTag || fromAuthor
              ? AppBar(
                  title: Text(
                      'Articles ${fromAuthor ? 'from' : 'about'} $subject'),
                )
              : null,
          backgroundColor: const Color(0xFF0a0a23),
          body: FutureBuilder(
            future: model.fetchArticles(slug, author),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return articleThumbnailBuilder(model, context);
              } else if (snapshot.hasError) {
                return errorMessage();
              }
              return const Center(child: CircularProgressIndicator());
            },
          )),
    );
  }

  Column errorMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'There was an error loading articles ',
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: const Text(
              'read articles online',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromRGBO(0x99, 0xc9, 0xff, 1)),
            ),
            onTap: () {
              launch('https://www.freecodecamp.org/news/');
            },
          ),
        ),
      ],
    );
  }

  ListView articleThumbnailBuilder(NewsFeedModel model, BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: model.articles.length,
        physics: const ClampingScrollPhysics(),
        separatorBuilder: (context, int i) => const Divider(
              color: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              thickness: 3,
              height: 3,
            ),
        itemBuilder: (BuildContext contex, int i) => NewsFeedLazyLoading(
            articleCreated: () {
              SchedulerBinding.instance!.addPostFrameCallback(
                  (timeStamp) => model.handleArticleLazyLoading(i));
            },
            child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  model.navigateTo(model.articles[i].id);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: thumbnailView(context, model, model.articles, i),
                ))));
  }

  Column thumbnailView(BuildContext context, NewsFeedModel model,
      List<Article>? articles, int i) {
    return Column(
      children: [
        Stack(children: [
          Container(
              color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              child: const AspectRatio(
                aspectRatio: 16 / 9,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                )),
              )),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              articles![i].featureImage,
              fit: BoxFit.cover,
            ),
          ),
        ]),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Wrap(
              children: [
                for (int j = 0; j < articles[i].tagNames.length && j < 3; j++)
                  articles[i].tagNames[j]
              ],
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            child: articleHeader(model, articles, i))
      ],
    );
  }

  Widget articleHeader(NewsFeedModel model, List<Article>? articles, int i) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                articles![i].title,
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 20, overflow: TextOverflow.ellipsis, height: 1.5),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 16),
              child: InkWell(
                onTap: () {
                  model.navigateToAuthor(articles[i].authorSlug);
                },
                child: Stack(
                  children: [
                    Container(
                        width: 45,
                        height: 45,
                        color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
                    Image.network(
                      articles[i].profileImage,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 16),
                    child: Text(
                      articles[i].authorName.toUpperCase(),
                    ),
                  ),
                  Text(
                    NewsFeedModel.parseDate(articles[i].createdAt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
