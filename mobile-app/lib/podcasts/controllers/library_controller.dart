import 'package:freecodecamp/podcasts/services/library_service.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_controller.g.dart';

@riverpod
class PodcastLibraryNotifier extends _$PodcastLibraryNotifier {
  @override
  Future<PodcastLibrary> build() =>
      ref.watch(podcastLibraryServiceProvider).getLibrary();

  Future<void> refresh() async {
    final library = await ref.read(podcastLibraryServiceProvider).getLibrary();
    if (ref.mounted) state = AsyncData(library);
  }

  Future<void> remove(String podcastId, String episodeId) async {
    final handler = ref.read(audioHandlerProvider);
    if (handler.episodeId == episodeId) await handler.stop();

    await ref
        .read(podcastLibraryServiceProvider)
        .removeEpisode(podcastId, episodeId);
    if (!ref.mounted) return;

    await refresh();
  }
}
