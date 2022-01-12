import 'package:flutter/material.dart';
import 'package:freecodecamp/models/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-author/news_author_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NewsAuthorView extends StatelessWidget {
  const NewsAuthorView({Key? key, required this.authorSlug}) : super(key: key);

  final String authorSlug;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsAuthorViewModel>.reactive(
        viewModelBuilder: () => NewsAuthorViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: const Text("Author profile"),
              ),
              body: FutureBuilder<Author>(
                  future: model.fetchAuthor(authorSlug),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Author? author = snapshot.data;

                      return Image.network(author!.profileImage);
                    }

                    return const Center(child: CircularProgressIndicator());
                  }),
            ));
  }
}
