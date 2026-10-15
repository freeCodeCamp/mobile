import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/podcasts/constants.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/ui/downloads/downloads_view.dart';
import 'package:mobile_app_new/podcasts/ui/podcast_list/podcast_list_viewmodel.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/podcast_grid_tile.dart';
import 'package:mobile_app_new/routing/podcasts.dart';

class PodcastListView extends ConsumerWidget {
  const PodcastListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcasts = ref.watch(podcastListProvider);
    return podcasts.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => PodcastDownloadsView(
        offline: true,
        onRetry: () => ref.invalidate(podcastListProvider),
      ),
      data: (podcasts) {
        final fcc = podcasts
            .where((p) => fccPodcastUrls.contains(p.feedUrl))
            .toList();
        final community = podcasts
            .where((p) => !fccPodcastUrls.contains(p.feedUrl))
            .toList();
        return RefreshIndicator(
          onRefresh: () async {
            await ref
                .refresh(podcastListProvider.future)
                .then<void>((_) {}, onError: (_) {});
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (fcc.isNotEmpty)
                _PodcastGroup(title: 'From freeCodeCamp', podcasts: fcc),
              if (community.isNotEmpty)
                _PodcastGroup(
                  title: 'More developer podcasts',
                  podcasts: community,
                ),
              if (podcasts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('No podcasts available yet.')),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PodcastGroup extends StatelessWidget {
  const _PodcastGroup({required this.title, required this.podcasts});
  final String title;
  final List<Podcast> podcasts;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          Material(
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colors.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < podcasts.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: colors.outlineVariant),
                  PodcastGridTile(
                    key: ValueKey(podcasts[i].id),
                    podcast: podcasts[i],
                    onTap: () => PodcastEpisodeListRoute(
                      podcastId: podcasts[i].id,
                    ).push(context),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
