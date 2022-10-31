import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/models/news/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_lazyloading.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
      onModelReady: (model) async => {await model.devMode(), model.init()},
      builder: (context, model, child) => Scaffold(
          drawer: !fromAuthor && !fromTag ? const DrawerWidgetView() : null,
          appBar: AppBar(
            title: fromAuthor || fromTag
                ? Text('Articles ${fromAuthor ? 'from' : 'about'} $subject')
                : const Text('NEWS FEED'),
            actions: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(4),
                    color: model.liteMode
                        ? Colors.white.withOpacity(0.84)
                        : Colors.transparent,
                    child: IconButton(
                      onPressed: () {
                        model.setLiteModeCache();
                      },
                      splashRadius: 0.1,
                      icon: Icon(
                        Icons.lte_mobiledata,
                        color: model.liteMode ? Colors.black : Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          backgroundColor: const Color(0xFF0a0a23),
          body: FutureBuilder(
            future: !model.devmode
                ? model.fetchArticles(slug, author)
                : model.readFromFiles(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                    backgroundColor: const Color(0xFF0a0a23),
                    color: Colors.white,
                    child: articleThumbnailBuilder(model),
                    onRefresh: () {
                      return model.refresh();
                    });
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
          'There was an error loading articles',
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
              launchUrlString('https://www.freecodecamp.org/news/');
            },
          ),
        ),
      ],
    );
  }

  ListView articleThumbnailBuilder(NewsFeedModel model) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: model.articles.length,
      physics: const ClampingScrollPhysics(),
      separatorBuilder: (context, int i) => Divider(
        color: model.liteMode
            ? Colors.transparent
            : const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
        thickness: 3,
        height: 3,
      ),
      itemBuilder: (BuildContext contex, int i) => NewsFeedLazyLoading(
        key: Key(model.articles[i].id),
        articleCreated: () {
          SchedulerBinding.instance.addPostFrameCallback(
              (timeStamp) => model.handleArticleLazyLoading(i));
        },
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            model.navigateTo(model.articles[i].id);
          },
          child: model.liteMode
              ? Card(
                  margin: const EdgeInsets.all(4),
                  color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 100),
                      child: thumbnailView(model, i),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: thumbnailView(model, i),
                ),
        ),
      ),
    );
  }

  Column thumbnailView(NewsFeedModel model, int i) {
    Article article = model.articles[i];

    return Column(
      children: [
        if (!model.liteMode)
          Container(
            color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: article.featureImage,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )),
          ),
        Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            child: articleHeader(model, i))
      ],
    );
  }

  Widget tagRow(Article article) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 16),
        child: Wrap(
          children: [
            for (int j = 0; j < article.tagNames.length && j < 3; j++)
              article.tagNames[j]
          ],
        ),
      ),
    );
  }

  Widget articleHeader(NewsFeedModel model, int i) {
    Article article = model.articles[i];

    return Column(
      children: [
        if (model.liteMode) authorCard(model, article) else tagRow(article),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  article.title,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 19,
                      overflow: TextOverflow.ellipsis,
                      height: 1.2,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        if (!model.liteMode) authorCard(model, article) else tagRow(article),
      ],
    );
  }

  Row authorCard(NewsFeedModel model, Article article) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 16),
          child: InkWell(
              onTap: () {
                model.navigateToAuthor(article.authorSlug);
              },
              child: Container(
                  width: 45,
                  height: 45,
                  color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                  child: article.profileImage == null
                      ? Image.asset(
                          'assets/images/placeholder-profile-img.png',
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: article.profileImage as String,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ))),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 16),
              child: Text(
                article.authorName.toUpperCase(),
              ),
            ),
            Text(
              NewsFeedModel.parseDate(article.createdAt),
            ),
          ],
        ),
      ],
    );
  }
}
