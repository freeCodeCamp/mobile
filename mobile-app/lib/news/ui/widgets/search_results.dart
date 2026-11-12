import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/news/models/search_post_model.dart';
import 'package:freecodecamp/news/ui/widgets/search_result_tile.dart';
import 'package:freecodecamp/widgets/chip_surface.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

class NewsSearchResults extends StatelessWidget {
  const NewsSearchResults({
    super.key,
    required this.results,
    required this.query,
    required this.onRetry,
    required this.onSuggestion,
  });

  final AsyncValue<List<SearchPost>> results;
  final String query;
  final VoidCallback onRetry;
  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) => results.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, _) => ErrorRetry(
      message: 'Unable to search articles.',
      detail:
          'Something went wrong on our side or with your connection. Your progress is safe.',
      onRetry: onRetry,
    ),
    data: (posts) => CustomScrollView(
      primary: false,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        if (posts.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Text(
                '${posts.length} ${posts.length == 1 ? 'result' : 'results'} for “$query”',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        if (posts.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: NewsSearchEmptyState(onSuggestion: onSuggestion),
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
              itemBuilder: (_, index) =>
                  NewsSearchResultTile(post: posts[index]),
            ),
          ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
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
                ChipSurface(
                  child: ActionChip(
                    label: Text(term),
                    onPressed: () => onSuggestion(term),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
