import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/news/api_service.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class TutorialList extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  TutorialList({
    super.key,
    required this.authorSlug,
    required this.authorName,
    required this.authorId,
  });

  final String authorSlug;
  final String authorName;
  final String authorId;
  final _navigationService = locator<NavigationService>();
  final _newsApiService = locator<NewsApiService>();

  Future<List<Tutorial>> fetchList() async {
    List<Tutorial> tutorials = [];

    await dotenv.load();

    final data = await _newsApiService.getPostsByAuthor(authorId);
    final postsData = data.posts;

    for (int i = 0; i < postsData.length; i++) {
      tutorials.add(Tutorial.fromJson(postsData[i]['node']));
    }
    return tutorials;
  }

  void navigateToTutorial(String id, String slug) {
    _navigationService.navigateTo(
      Routes.newsTutorialView,
      arguments: NewsTutorialViewArguments(
        refId: id,
        slug: slug,
      ),
    );
  }

  void navigateToFeed() {
    _navigationService.navigateTo(
      Routes.newsFeedView,
      arguments: NewsFeedViewArguments(
        fromAuthor: true,
        authorId: authorId,
        subject: authorName,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => TutorialListState();
}

class TutorialListState extends State<TutorialList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Tutorial>>(
      future: widget.fetchList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
              if (snapshot.data!.length > 5)
                Container(
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.only(bottom: 48),
                  child: ListTile(
                    title: Text(
                      context.t.tutorial_show_more,
                    ),
                    tileColor: const Color(0xFF0a0a23),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () {
                      widget.navigateToFeed();
                    },
                  ),
                ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class TileLayout extends StatelessWidget {
  const TileLayout({super.key, required this.widget, required this.snapshot});

  final TutorialList widget;
  final AsyncSnapshot<List<Tutorial>> snapshot;

  @override
  Widget build(BuildContext context) {
    double imgSize = MediaQuery.of(context).size.width * 0.25;

    return Expanded(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(
          height: 4,
        ),
        shrinkWrap: true,
        padding: const EdgeInsets.all(4),
        itemCount: snapshot.data!.length > 5 ? 5 : snapshot.data?.length ?? 1,
        itemBuilder: (context, index) {
          Tutorial tutorial = snapshot.data![index];
          return ListTile(
            title: Text(
              tutorial.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            tileColor: const Color(0xFF0a0a23),
            isThreeLine: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            subtitle: Text(
              NewsFeedViewModel.parseDate(tutorial.createdAt),
            ),
            trailing: Container(
              constraints: BoxConstraints(
                minWidth: imgSize,
                maxWidth: imgSize,
              ),
              child: tutorial.featureImage == null
                  ? Image.asset(
                      'assets/images/freecodecamp-banner.png',
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      tutorial.featureImage!,
                      fit: BoxFit.cover,
                    ),
            ),
            onTap: () {
              widget.navigateToTutorial(
                tutorial.id,
                tutorial.slug,
              );
            },
          );
        },
      ),
    );
  }
}
