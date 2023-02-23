import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
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
          title: Container(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: TextField(
                controller: model.searchbarController,
                decoration: const InputDecoration(
                  hintText: 'SEARCH TUTORIALS...',
                  fillColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
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
          ),
          actions: [
            Container(
              color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              margin: const EdgeInsets.fromLTRB(4, 4, 32, 4),
              child: IconButton(
                onPressed: model.searchbarController.text != '' && model.hasData
                    ? () {
                        model.searchSubject();
                      }
                    : null,
                icon: const Icon(
                  Icons.search_sharp,
                ),
                style: TextButton.styleFrom(
                  disabledBackgroundColor:
                      const Color.fromARGB(255, 35, 35, 48),
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
              return const Center(
                child: Text('No Tutorials Found'),
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
                                    current[index].data['title']
                                  ),
                                },
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Text('No Tutorials Found'),
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
