import 'package:flutter/material.dart';
import 'package:freecodecamp/models/forum/forum_search_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-search/forum_search_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ForumSearchView extends StatelessWidget {
  const ForumSearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumSearchModel>.reactive(
        viewModelBuilder: () => ForumSearchModel(),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: TextField(
                decoration: const InputDecoration(
                    hintText: 'SEARCH TOPIC...',
                    hintStyle: TextStyle(color: Colors.white),
                    fillColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                    filled: true),
                onSubmitted: (value) {
                  model.checkQuery(value);
                },
              ),
            ),
            body: model.searchTerm.isNotEmpty
                ? StreamBuilder<List<SearchModel>>(
                    stream: Stream.fromFuture(model.search(model.searchTerm)),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<SearchModel> result = snapshot.data ?? [];

                        return searchTile(result, model);
                      }

                      return Container();
                    },
                  )
                : Center(
                    child: Text(
                    model.hasSearched
                        ? model.queryToShort
                            ? 'Query too short'
                            : ''
                        : 'Type something to search',
                  ))));
  }

  ListView searchTile(List<SearchModel> result, ForumSearchModel model) {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: result.length,
        separatorBuilder: (context, int i) => const Divider(
              color: Color.fromRGBO(0x42, 0x42, 0x55, 1),
              thickness: 1,
            ),
        itemBuilder: (context, index) {
          var searchResult = result[index];
          return ListTile(
            onTap: () {
              model.goToPost(searchResult.slug, searchResult.topicId);
            },
            title: Text(
              searchResult.title,
            ),
          );
        });
  }
}
