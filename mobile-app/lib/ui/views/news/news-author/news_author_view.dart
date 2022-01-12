import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-author/news_author_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NewsAuthorView extends StatelessWidget {
  const NewsAuthorView({Key? key, required this.authorSlug}) : super(key: key);

  final String authorSlug;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsAuthorViewModel>.reactive(
        viewModelBuilder: () => NewsAuthorViewModel(),
        onModelReady: (model) => model.fetchAuthor(authorSlug),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(),
              body: Column(),
            ));
  }
}
