import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_widget.dart';
import 'package:freecodecamp/ui/views/news/news-tutorial/news_tutorial_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/widgets/back_to_top_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';

class NewsTutorialHeader extends StatelessWidget {
  const NewsTutorialHeader({super.key, required this.tutorial});

  final Tutorial tutorial;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
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
        Row(
          children: [
            Expanded(
              child: Container(
                color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tutorial.title,
                      style: const TextStyle(
                        fontSize: 24,
                        height: 1.5,
                      ),
                      key: const Key('title'),
                    ),
                    Text(
                      context.t.tutorial_written_by(
                        tutorial.authorName,
                      ),
                      style: const TextStyle(
                        height: 1.5,
                      ),
                    ),
                    Wrap(
                      children: [
                        for (int j = 0;
                            j < tutorial.tagNames.length && j < 3;
                            j++)
                          tutorial.tagNames[j]
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NewsTutorialView extends StatelessWidget {
  const NewsTutorialView({
    super.key,
    required this.refId,
    required this.title,
    required this.slug,
  });
  final String refId;
  final String title;
  final String slug;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsTutorialViewModel>.reactive(
      onViewModelReady: (model) => model.initState(refId),
      onDispose: (model) => model.removeScrollPosition(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFF0a0a23),
        body: FutureBuilder<Tutorial>(
          future: model.initState(refId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var tutorial = snapshot.data;
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        lazyLoadHtml(tutorial!.text!, context, tutorial, model),
                        bottomButtons(tutorial, model, context),
                      ],
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              throw Exception(snapshot.error);
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: model.showToTopButton
            ? BackToTopButton(
                onPressed: () => model.goToTop(),
              )
            : null,
      ),
      viewModelBuilder: () => NewsTutorialViewModel(),
    );
  }

  Widget bottomButtons(
    Tutorial tutorial,
    NewsTutorialViewModel model,
    BuildContext context,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 75,
        width: 300,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          controller: model.bottomButtonController,
          children: [
            Row(
              children: [
                Container(
                  height: 150,
                ),
                NewsBookmarkViewWidget(tutorial: tutorial),
                const SizedBox(
                  height: 35,
                  child: VerticalDivider(
                    color: Colors.white,
                    width: 0,
                  ),
                ),
                BottomButton(
                  label: context.t.share,
                  icon: Icons.share,
                  onPressed: () {
                    Share.share('${tutorial.title}\n\n${tutorial.url}');
                  },
                  rightSided: true,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ListView lazyLoadHtml(
    String html,
    BuildContext context,
    Tutorial tutorial,
    NewsTutorialViewModel model,
  ) {
    var htmlToList = model.initLazyLoading(html, context, tutorial);

    return ListView.builder(
      shrinkWrap: true,
      controller: model.scrollController,
      itemCount: htmlToList.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        return Row(
          children: [
            Expanded(child: htmlToList[i]),
          ],
        );
      },
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
    required this.rightSided,
  });

  final Function onPressed;
  final String label;
  final bool rightSided;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        onPressed: () {
          onPressed();
        },
        label: Text(label),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(rightSided ? 0 : 10),
              topRight: Radius.circular(rightSided ? 10 : 0),
              bottomLeft: Radius.circular(rightSided ? 0 : 10),
              bottomRight: Radius.circular(rightSided ? 10 : 0),
            ),
          ),
          backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
        ),
      ),
    );
  }
}
