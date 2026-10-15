import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/news/models/search_post_model.dart';
import 'package:mobile_app_new/news/ui/search/search_viewmodel.dart';
import 'package:mobile_app_new/news/ui/widgets/search_result_tile.dart';

class NewsSearchView extends ConsumerStatefulWidget {
  const NewsSearchView({super.key});

  @override
  ConsumerState<NewsSearchView> createState() => _NewsSearchViewState();
}

class _NewsSearchViewState extends ConsumerState<NewsSearchView> {
  final TextEditingController _searchBarController = TextEditingController();

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  void _onSearchTermChanged(String term) =>
      ref.read(newsSearchProvider.notifier).search(term);

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(newsSearchProvider);

    return Column(
      children: [
        TextField(
          controller: _searchBarController,
          onChanged: _onSearchTermChanged,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'SEARCH TUTORIALS...',
            fillColor: FccColors.gray80,
            filled: true,
            border: InputBorder.none,
          ),
        ),
        const Divider(color: FccColors.gray90, thickness: 4, height: 4),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: _searchBarController,
            builder: (context, value, _) => value.text.isEmpty
                ? const Center(child: Text('Search for tutorials'))
                : _buildResults(results),
          ),
        ),
      ],
    );
  }

  Widget _buildResults(AsyncValue<List<SearchPost>> results) {
    return results.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        log('Error loading tutorials: $error\n$stackTrace');
        return const Center(
          child: Text(
            'There was an error loading tutorials \n please try again',
            textAlign: TextAlign.center,
          ),
        );
      },
      data: (posts) => posts.isEmpty
          ? const Center(child: Text('No Tutorials Found'))
          : _buildResultsList(posts),
    );
  }

  Widget _buildResultsList(List<SearchPost> posts) {
    return Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        itemCount: posts.length,
        separatorBuilder: (context, index) =>
            Divider(color: FccColors.gray80, thickness: 1, height: 1),
        itemBuilder: (context, index) => SearchResultTile(post: posts[index]),
      ),
    );
  }
}
