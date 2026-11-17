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
        retry: noRetry,
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
    r'6ed7e4d51a9767c2721e7bd3b6eca5f256e6c740';

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

@ProviderFor(podcastDownloadedPodcasts)
final podcastDownloadedPodcastsProvider = PodcastDownloadedPodcastsProvider._();

final class PodcastDownloadedPodcastsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Podcast>>,
          AsyncValue<List<Podcast>>,
          AsyncValue<List<Podcast>>
        >
    with $Provider<AsyncValue<List<Podcast>>> {
  PodcastDownloadedPodcastsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastDownloadedPodcastsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastDownloadedPodcastsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Podcast>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Podcast>> create(Ref ref) {
    return podcastDownloadedPodcasts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Podcast>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Podcast>>>(value),
    );
  }
}

String _$podcastDownloadedPodcastsHash() =>
    r'4580757ffa588b945d86392d691156e2dbe1c75c';

@ProviderFor(podcastDownloadedEpisodeCount)
final podcastDownloadedEpisodeCountProvider =
    PodcastDownloadedEpisodeCountFamily._();

final class PodcastDownloadedEpisodeCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  PodcastDownloadedEpisodeCountProvider._({
    required PodcastDownloadedEpisodeCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'podcastDownloadedEpisodeCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$podcastDownloadedEpisodeCountHash();

  @override
  String toString() {
    return r'podcastDownloadedEpisodeCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as String;
    return podcastDownloadedEpisodeCount(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PodcastDownloadedEpisodeCountProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podcastDownloadedEpisodeCountHash() =>
    r'c851b716d986a44ed6f0c3d4b5ca82f3b950da13';

final class PodcastDownloadedEpisodeCountFamily extends $Family
    with $FunctionalFamilyOverride<int, String> {
  PodcastDownloadedEpisodeCountFamily._()
    : super(
        retry: null,
        name: r'podcastDownloadedEpisodeCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PodcastDownloadedEpisodeCountProvider call(String podcastId) =>
      PodcastDownloadedEpisodeCountProvider._(argument: podcastId, from: this);

  @override
  String toString() => r'podcastDownloadedEpisodeCountProvider';
}

@ProviderFor(podcastDownloadedPodcastSize)
final podcastDownloadedPodcastSizeProvider =
    PodcastDownloadedPodcastSizeFamily._();

final class PodcastDownloadedPodcastSizeProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  PodcastDownloadedPodcastSizeProvider._({
    required PodcastDownloadedPodcastSizeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'podcastDownloadedPodcastSizeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$podcastDownloadedPodcastSizeHash();

  @override
  String toString() {
    return r'podcastDownloadedPodcastSizeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    final argument = this.argument as String;
    return podcastDownloadedPodcastSize(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PodcastDownloadedPodcastSizeProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podcastDownloadedPodcastSizeHash() =>
    r'8beede564797629e0d3d770b727819ff5e054e73';

final class PodcastDownloadedPodcastSizeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int?>, String> {
  PodcastDownloadedPodcastSizeFamily._()
    : super(
        retry: null,
        name: r'podcastDownloadedPodcastSizeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PodcastDownloadedPodcastSizeProvider call(String podcastId) =>
      PodcastDownloadedPodcastSizeProvider._(argument: podcastId, from: this);

  @override
  String toString() => r'podcastDownloadedPodcastSizeProvider';
}

@ProviderFor(podcastDownloadedSize)
final podcastDownloadedSizeProvider = PodcastDownloadedSizeFamily._();

final class PodcastDownloadedSizeProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  PodcastDownloadedSizeProvider._({
    required PodcastDownloadedSizeFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'podcastDownloadedSizeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$podcastDownloadedSizeHash();

  @override
  String toString() {
    return r'podcastDownloadedSizeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return podcastDownloadedSize(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is PodcastDownloadedSizeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podcastDownloadedSizeHash() =>
    r'992b8be0de75f3de64843508fe3da0a08fc8ce58';

final class PodcastDownloadedSizeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int?>, (String, String)> {
  PodcastDownloadedSizeFamily._()
    : super(
        retry: null,
        name: r'podcastDownloadedSizeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PodcastDownloadedSizeProvider call(String podcastId, String episodeId) =>
      PodcastDownloadedSizeProvider._(
        argument: (podcastId, episodeId),
        from: this,
      );

  @override
  String toString() => r'podcastDownloadedSizeProvider';
}
