import 'package:flutter/material.dart';
import 'package:freecodecamp/models/news/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-author/news_author_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/article_list_widget.dart';
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
                title: const Text('Author profile'),
              ),
              body: SingleChildScrollView(
                child: FutureBuilder<Author>(
                    future: model.fetchAuthor(authorSlug),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Author? author = snapshot.data;

                        return view(model, context, author);
                      }

                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
            ));
  }

  Column view(NewsAuthorViewModel model, BuildContext ctxt, Author? author) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 175,
                  height: 175,
                  color: const Color(0xFF0a0a23),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: profilePicture(author),
            )
          ],
        ),
        Text(
          author!.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 28, height: 2),
        ),
        author.location != null
            ? Text(
                author.location as String,
                style: const TextStyle(fontSize: 16),
              )
            : Container(),
        author.bio != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  author.bio as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : Container(),
        ArticleList(
          authorSlug: author.slug,
          authorName: author.name,
        ),
      ],
    );
  }

  Align profilePicture(Author? author) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 175,
        height: 175,
        decoration:
            BoxDecoration(border: Border.all(width: 2, color: Colors.white)),
        child: Image.network(
          author!.profileImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
