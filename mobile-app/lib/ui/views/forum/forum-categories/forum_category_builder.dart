import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/forum/forum_category_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_viewmodel.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stacked/stacked.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class ForumCategoryBuilder extends StatelessWidget {
  const ForumCategoryBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumCategoryViewModel>.reactive(
        viewModelBuilder: () => ForumCategoryViewModel(),
        onModelReady: (model) => model.initState(),
        builder: (context, model, child) => Scaffold(
                body: FutureBuilder<List<Category>>(
              future: model.future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var categories = snapshot.data;
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int i) {
                        return InkWell(
                          onTap: () {
                            model.goToPosts(categories![i].slug,
                                categories[i].id, categories[i].name);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        width: 5,
                                        color: HexColor(
                                          "#" + categories![i].color,
                                        )))),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(categories[i].name,
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Html(
                                              data: categories[i].description,
                                              style: {
                                                "body": Style(
                                                    color: Colors.white,
                                                    fontSize: FontSize.rem(1.2))
                                              },
                                              onLinkTap: (String? url,
                                                  RenderContext context,
                                                  Map<String, String>
                                                      attributes,
                                                  dom.Element? element) {
                                                launch(url!);
                                              },
                                            )))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                          categories[i].topicWeek.toString() +
                                              ' new topics this week',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300)),
                                    ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const Center(child: CircularProgressIndicator());
              },
            )));
  }
}
