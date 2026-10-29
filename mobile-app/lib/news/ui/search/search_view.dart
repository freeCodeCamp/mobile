import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/news/models/search_post_model.dart';
import 'package:freecodecamp/news/ui/search/search_viewmodel.dart';
import 'package:freecodecamp/news/ui/widgets/search_result_tile.dart';
import 'package:freecodecamp/routing/news.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:go_router/go_router.dart';

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
                    hintText: 'Search articles',
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
                    fillColor: colors.surfaceContainer,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.primary, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _searchBarController.text.trim().isEmpty
              ? const SizedBox.shrink()
              : _buildResults(results),
        ),
      ],
    );
  }

  Widget _buildResults(AsyncValue<List<SearchPost>> results) => results.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, _) => ErrorRetry(
      message: 'Unable to search articles.',
      onRetry: () => _search(_searchBarController.text),
    ),
    data: (posts) => CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        if (posts.isNotEmpty)
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
          SliverFillRemaining(
            hasScrollBody: false,
            child: NewsSearchEmptyState(
              onSuggestion: (term) {
                _searchBarController.text = term;
                _search(term);
              },
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

class NewsSearchEmptyState extends StatelessWidget {
  const NewsSearchEmptyState({super.key, required this.onSuggestion});
  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_rounded),
          ),
          const SizedBox(height: 16),
          const Text(
            'No articles found',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a shorter search or a different word.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final term in const ['JavaScript', 'Python', 'CSS'])
                ActionChip(
                  label: Text(term),
                  onPressed: () => onSuggestion(term),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
