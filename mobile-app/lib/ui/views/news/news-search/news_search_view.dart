import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NewsSearchView extends StatelessWidget {
  const NewsSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsSearchModel>.reactive(
      viewModelBuilder: () => NewsSearchModel(),
      onViewModelReady: (model) => model.init(),
      onDispose: (model) => model.onDispose(),
      builder: (context, model, child) {
        // final isSearchable = model.searchbarController.text != '' &&
        //     !model.isLoading &&
        //     model.hasData;

        return Scaffold(
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
                model.setHasData = false;
                model.setIsLoading = true;
              },
              // onSubmitted: isSearchable
              //     ? (value) {
              //         model.searchSubject();
              //       }
              //     : (value) {},
            ),
            // actions: [
            //   Container(
            //     margin: const EdgeInsets.only(left: 8),
            //     color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            //     child: IconButton(
            //       onPressed: isSearchable
            //           ? () {
            //               model.searchSubject();
            //             }
            //           : null,
            //       icon: const Icon(
            //         Icons.search_sharp,
            //       ),
            //     ),
            //   )
            // ],
          ),
          body: StreamBuilder<SearchResponse>(
            stream: model.algolia.responses,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'There was an error loading tutorials \n please try again',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting ||
                  model.isLoading) {
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

              final currentData = snapshot.data!.hits;

              return Column(
                children: [
                  Expanded(
                    child: currentData.isNotEmpty
                        ? Scrollbar(
                            thumbVisibility: true,
                            trackVisibility: true,
                            child: ListView.separated(
                              physics: const ClampingScrollPhysics(),
                              itemCount: currentData.length,
                              separatorBuilder: (context, int i) =>
                                  const Divider(
                                color: Color.fromRGBO(0x42, 0x42, 0x55, 1),
                                thickness: 2,
                                height: 5,
                              ),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    currentData[index]['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.87),
                                    ),
                                  ),
                                  onTap: () => {
                                    model.navigateToTutorial(
                                        currentData[index]['objectID'],
                                        currentData[index]['slug']),
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
        );
      },
    );
  }
}
