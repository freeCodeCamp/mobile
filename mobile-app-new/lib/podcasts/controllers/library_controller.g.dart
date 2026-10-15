// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PodcastLibraryNotifier)
final podcastLibraryProvider = PodcastLibraryNotifierProvider._();

final class PodcastLibraryNotifierProvider
    extends $AsyncNotifierProvider<PodcastLibraryNotifier, PodcastLibrary> {
  PodcastLibraryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastLibraryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastLibraryNotifierHash();

  @$internal
  @override
  PodcastLibraryNotifier create() => PodcastLibraryNotifier();
}

String _$podcastLibraryNotifierHash() =>
    r'72bd2cd9299b782bf76958b6b03fd0ca6ca966d8';

abstract class _$PodcastLibraryNotifier extends $AsyncNotifier<PodcastLibrary> {
  FutureOr<PodcastLibrary> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PodcastLibrary>, PodcastLibrary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PodcastLibrary>, PodcastLibrary>,
              AsyncValue<PodcastLibrary>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
