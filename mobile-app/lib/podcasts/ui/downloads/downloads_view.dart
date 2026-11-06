import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/ui/widgets/downloads_management_list.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_artwork.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_format.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/routing/podcasts.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:intl/intl.dart';

class PodcastDownloadsView extends ConsumerWidget {
  const PodcastDownloadsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcasts = ref.watch(podcastDownloadedPodcastsProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) const AccountRoute().go(context);
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text('Downloads'),
          leading: IconButton(
            tooltip: 'Back to Account',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => const AccountRoute().go(context),
          ),
        ),
        bottomNavigationBar: const AppNavigationFooter(
          selected: AppDestination.account,
        ),
        body: podcasts.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => ErrorRetry(
            message: 'Unable to load downloads.',
            onRetry: () => ref.invalidate(podcastLibraryProvider),
          ),
          data: (podcasts) => DownloadManagementList(
            items: podcasts.map((podcast) => podcast.id).toList(),
            onRemove: (ids) =>
                ref.read(podcastLibraryProvider.notifier).removePodcasts(ids),
            emptyState: const DownloadsEmptyState(),
            itemBuilder: (context, index, managing, selected, onSelect) =>
                PodcastDownloadGroupTile(
                  podcast: podcasts[index],
                  managing: managing,
                  selected: selected,
                  onSelect: onSelect,
                ),
          ),
        ),
      ),
    );
  }
}

class PodcastDownloadGroupTile extends ConsumerWidget {
  const PodcastDownloadGroupTile({
    super.key,
    required this.podcast,
    required this.managing,
    required this.selected,
    required this.onSelect,
  });

  final Podcast podcast;
  final bool managing;
  final bool selected;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final count = ref.watch(podcastDownloadedEpisodeCountProvider(podcast.id));
    final bytes = ref
        .watch(podcastDownloadedPodcastSizeProvider(podcast.id))
        .value;
    final locale = Localizations.localeOf(context).toString();
    final details = [
      '${NumberFormat.decimalPattern(locale).format(count)} ${count == 1 ? 'episode' : 'episodes'}',
      if (bytes != null) podcastFileSize(bytes, locale),
    ].join(' · ');
    return InkWell(
      onTap: managing
          ? onSelect
          : () => PodcastEpisodeListRoute(
              podcastId: podcast.id,
              downloaded: true,
            ).push<void>(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Row(
          children: [
            PodcastArtwork(podcast: podcast, size: 52, radius: 8),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    podcast.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (managing)
              Checkbox(
                value: selected,
                onChanged: onSelect == null ? null : (_) => onSelect!(),
              )
            else
              Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
