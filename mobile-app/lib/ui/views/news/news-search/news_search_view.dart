import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NewsSearchView extends StatelessWidget {
  const NewsSearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsSearchModel>.reactive(
      viewModelBuilder: () => NewsSearchModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: TextField(
              controller: model.searchbarController,
              decoration: InputDecoration(
                hintText: context.t.tutorial_search_placeholder,
                fillColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                border: InputBorder.none,
                filled: true,
              ),
              onChanged: (value) {
                model.setSearchTerm(value);

                if (model.hasData) {
                  model.setHasData = false;
                }
              },
              onSubmitted: model.hasData
                  ? (value) {
                      model.searchSubject();
                    }
                  : (value) {}),
          actions: [
            Container(
              margin: const EdgeInsets.only(left: 8),
              color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              child: IconButton(
                onPressed: model.searchbarController.text != '' && model.hasData
                    ? () {
                        model.searchSubject();
                      }
                    : null,
                icon: const Icon(
                  Icons.search_sharp,
                ),
              ),
            )
          ],
        ),
        body: StreamBuilder<List<AlgoliaObjectSnapshot>>(
          stream: Stream.fromFuture(model.search(model.getSearchTerm)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  context.t.tutorial_search_no_results,
                ),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'There was an error loading tutorials \n please try again',
                  textAlign: TextAlign.center,
                ),
              );
            }

            List<AlgoliaObjectSnapshot>? current = snapshot.data;

            return Column(
              children: [
                Expanded(
                  child: current!.isNotEmpty
                      ? Scrollbar(
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: ListView.separated(
                            physics: const ClampingScrollPhysics(),
                            itemCount: current.length,
                            separatorBuilder: (context, int i) => const Divider(
                              color: Color.fromRGBO(0x42, 0x42, 0x55, 1),
                              thickness: 2,
                              height: 5,
                            ),
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  current[index].data['title'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.87),
                                  ),
                                ),
                                onTap: () => {
                                  model.navigateToTutorial(
                                      current[index].data['objectID'],
                                      current[index].data['title']),
                                },
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            context.t.tutorial_search_no_results,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
