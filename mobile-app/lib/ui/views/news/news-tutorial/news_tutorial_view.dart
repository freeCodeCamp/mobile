import 'package:flutter/material.dart';

import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'news_tutorial_model.dart';

class NewsTutorialView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  NewsTutorialView({Key? key, required this.refId}) : super(key: key);
  late final String refId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsTutorialViewModel>.reactive(
      onModelReady: (model) => model.initState(refId),
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
                      child: Stack(children: [
                    lazyLoadHtml(tutorial!.text!, context, tutorial, model),
                    bottomButtons(tutorial, model)
                  ]))
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
      ),
      viewModelBuilder: () => NewsTutorialViewModel(),
    );
  }

  Widget bottomButtons(Tutorial tutorial, NewsTutorialViewModel model) {
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
                  label: 'Share',
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

  ListView lazyLoadHtml(String html, BuildContext context, Tutorial tutorial,
      NewsTutorialViewModel model) {
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
        });
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.icon,
      required this.rightSided})
      : super(key: key);

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
                    bottomRight: Radius.circular(rightSided ? 10 : 0))),
            backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
      ),
    );
  }
}
