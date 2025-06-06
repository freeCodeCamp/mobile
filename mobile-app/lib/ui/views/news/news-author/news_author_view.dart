import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/ui/views/news/news-author/news_author_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/widgets/tutorial_list_widget.dart';
import 'package:stacked/stacked.dart';

class NewsAuthorView extends StatelessWidget {
  const NewsAuthorView({
    super.key,
    required this.authorSlug,
  });

  final String authorSlug;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsAuthorViewModel>.reactive(
      viewModelBuilder: () => NewsAuthorViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(context.t.tutorial_author_title),
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
            },
          ),
        ),
      ),
    );
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
            fontWeight: FontWeight.bold,
            fontSize: 28,
            height: 2,
          ),
        ),
        if (author.location != null)
          Text(
            author.location as String,
            style: const TextStyle(fontSize: 16),
          ),
        if (author.bio != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              author.bio as String,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        TutorialList(
          authorSlug: author.slug,
          authorName: author.name,
          authorId: author.id,
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
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
        ),
        child: author?.profileImage == null
            ? Image.asset(
                'assets/images/placeholder-profile-img.png',
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                imageUrl: author!.profileImage as String,
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/placeholder-profile-img.png',
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
