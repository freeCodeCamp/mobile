// ignore: file_names
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
                title: TextField(
              controller: model.searchbarController,
              decoration: const InputDecoration(
                  hintText: 'SEARCH ARTICLE...',
                  fillColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                  filled: true),
              onChanged: (value) {
                model.setSearchTerm(value);
              },
            )),
            body: StreamBuilder<List<AlgoliaObjectSnapshot>>(
              stream: Stream.fromFuture(model.search(model.getSearchTerm)),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) return Text('Error: ${snapshot.error}');

                List<AlgoliaObjectSnapshot>? current = snapshot.data;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          itemCount: current!.length,
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
                              ),
                              onTap: () => {
                                model.navigateToArticle(
                                    current[index].data['objectID'])
                              },
                            );
                          }),
                    )
                  ],
                );
              },
            )));
  }
}
