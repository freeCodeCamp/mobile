import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/news/controllers/feed_controller.dart';
import 'package:freecodecamp/news/models/post_model.dart';
import 'package:freecodecamp/news/ui/feed/feed_viewmodel.dart';
import 'package:freecodecamp/news/ui/widgets/post_feed_list.dart';
import 'package:freecodecamp/news/ui/widgets/search_field.dart';
import 'package:freecodecamp/news/ui/widgets/search_results.dart';
import 'package:freecodecamp/widgets/chip_surface.dart';

class NewsFeedView extends ConsumerStatefulWidget {
  const NewsFeedView({super.key});

  @override
  ConsumerState<NewsFeedView> createState() => _NewsFeedViewState();
}

class _NewsFeedViewState extends ConsumerState<NewsFeedView> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  Tag? _selectedTag;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _search(String term) {
    ref.read(newsSearchProvider.notifier).search(term.trim());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tags = ref.watch(newsFeedTagsProvider);
    final query = _searchController.text.trim();
    final results = ref.watch(newsSearchProvider);

    return Column(
      children: [
        NewsSearchField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: _search,
          onClear: () {
            _searchController.clear();
            _search('');
          },
        ),
        Expanded(
          child: IndexedStack(
            index: query.isEmpty ? 0 : 1,
            sizing: StackFit.expand,
            children: [
              NewsPostFeedList(
                key: ValueKey(_selectedTag?.slug),
                source: _selectedTag == null
                    ? const NewsFeedSource.all()
                    : NewsFeedSource.tag(_selectedTag!.slug),
                featured: true,
                header: SingleChildScrollView(
                  key: const PageStorageKey('news-feed-topics'),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    children: [
                      _filter(context, 'Latest', null),
                      for (final tag in tags) _filter(context, tag.name, tag),
                    ],
                  ),
                ),
              ),
              if (query.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: NewsSearchResults(
                    results: results,
                    query: query,
                    onRetry: () =>
                        ref.read(newsSearchProvider.notifier).retry(),
                    onSuggestion: (term) {
                      _searchController.text = term;
                      _search(term);
                    },
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filter(BuildContext context, String label, Tag? tag) {
    final selected = _selectedTag?.slug == tag?.slug;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChipSurface(
        child: ChoiceChip(
          showCheckmark: false,
          label: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 22),
            child: Center(widthFactor: 1, child: Text(label)),
          ),
          selected: selected,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
          onSelected: (_) => setState(() => _selectedTag = tag),
        ),
      ),
    );
  }
}
