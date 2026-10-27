import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/news/controllers/feed_controller.dart';
import 'package:freecodecamp/news/models/post_model.dart';
import 'package:freecodecamp/news/models/post_summary_model.dart';
import 'package:freecodecamp/news/ui/widgets/post_feed_list.dart';
import 'package:freecodecamp/routing/news.dart';
import 'package:go_router/go_router.dart';

class NewsFeedView extends ConsumerStatefulWidget {
  const NewsFeedView({super.key});

  @override
  ConsumerState<NewsFeedView> createState() => _NewsFeedViewState();
}

class _NewsFeedViewState extends ConsumerState<NewsFeedView> {
  Tag? _selectedTag;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final allPosts = ref.watch(newsFeedProvider(const NewsFeedSource.all()));
    final tags = <String, Tag>{};
    for (final post in allPosts.value?.posts ?? const <PostSummary>[]) {
      for (final tag in post.tags) {
        tags.putIfAbsent(tag.slug, () => tag);
      }
    }

    return PostFeedList(
      key: ValueKey(_selectedTag?.slug),
      source: _selectedTag == null
          ? const NewsFeedSource.all()
          : NewsFeedSource.tag(_selectedTag!.slug),
      featured: true,
      header: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              color: colors.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: colors.outline),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.go(newsSearchPath),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Search articles',
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                _filter(context, 'Latest', null),
                for (final tag in tags.values.take(12))
                  _filter(context, tag.name, tag),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filter(BuildContext context, String label, Tag? tag) {
    final selected = _selectedTag?.slug == tag?.slug;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: colors.primary,
        backgroundColor: colors.surface,
        labelStyle: TextStyle(
          color: selected ? colors.onPrimary : colors.onSurface,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        ),
        side: BorderSide(color: selected ? colors.primary : colors.outline),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        onSelected: (_) => setState(() => _selectedTag = tag),
      ),
    );
  }
}
