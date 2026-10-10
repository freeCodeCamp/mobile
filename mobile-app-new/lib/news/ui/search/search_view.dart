import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/news/models/search_post_model.dart';
import 'package:mobile_app_new/news/ui/search/search_viewmodel.dart';
import 'package:mobile_app_new/news/ui/widgets/search_result_tile.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

class NewsSearchView extends ConsumerStatefulWidget {
  const NewsSearchView({super.key});

  @override
  ConsumerState<NewsSearchView> createState() => _NewsSearchViewState();
}

class _NewsSearchViewState extends ConsumerState<NewsSearchView> {
  final _searchBarController = TextEditingController();

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  void _search(String term) {
    ref.read(newsSearchProvider.notifier).search(term.trim());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(newsSearchProvider);
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 20, 8),
          child: Row(
            children: [
              BackButton(onPressed: () => context.go(newsFeedPath)),
              const SizedBox(width: 4),
              Expanded(
                child: TextField(
                  controller: _searchBarController,
                  autofocus: true,
                  onChanged: _search,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search tutorials',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchBarController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _searchBarController.clear();
                              _search('');
                            },
                          ),
                    fillColor: colors.surface,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.outlineVariant),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _searchBarController.text.trim().isEmpty
              ? Center(
                  child: Text(
                    'Find your next tutorial',
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                )
              : _buildResults(results),
        ),
      ],
    );
  }

  Widget _buildResults(AsyncValue<List<SearchPost>> results) => results.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, _) => ErrorRetry(
      message: 'Unable to search tutorials.',
      onRetry: () => _search(_searchBarController.text),
    ),
    data: (posts) => CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Text(
              '${posts.length} ${posts.length == 1 ? 'result' : 'results'} for “${_searchBarController.text.trim()}”',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        if (posts.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('No tutorials found. Try another search.'),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.separated(
              itemCount: posts.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              itemBuilder: (_, index) => SearchResultTile(post: posts[index]),
            ),
          ),
      ],
    ),
  );
}
