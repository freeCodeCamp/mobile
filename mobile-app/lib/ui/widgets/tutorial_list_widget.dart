import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class TutorialList extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  TutorialList({
    Key? key,
    required this.authorSlug,
    required this.authorName,
  }) : super(key: key);

  final String authorSlug;
  final String authorName;
  final _navigationService = locator<NavigationService>();
  final _dio = DioService.dio;

  Future<List<Tutorial>> fetchList() async {
    List<Tutorial> tutorials = [];

    await dotenv.load();

    String par =
        '&fields=title,url,feature_image,slug,published_at,id&include=tags,authors';
    String url =
        "${dotenv.env['NEWSURL']}posts/?key=${dotenv.env['NEWSKEY']}&page=1$par&filter=author:$authorSlug";

    final Response response = await _dio.get(url);

    if (response.statusCode == 200) {
      var tutorialJson = response.data['posts'];
      for (int i = 0; i < tutorialJson?.length; i++) {
        tutorials.add(Tutorial.fromJson(tutorialJson[i]));
      }
      return tutorials;
    } else {
      throw Exception('Something when wrong when fetching $url');
    }
  }

  void navigateToTutorial(String id, String title) {
    _navigationService.navigateTo(Routes.newsTutorialView,
        arguments: NewsTutorialViewArguments(refId: id, title: title));
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
  const TileLayout({Key? key, required this.widget, required this.snapshot})
      : super(key: key);

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
              widget.navigateToTutorial(tutorial.id, tutorial.title);
            },
          );
        },
      ),
    );
  }
}
