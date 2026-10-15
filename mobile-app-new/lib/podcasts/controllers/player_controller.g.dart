// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(podcastPlaybackPosition)
final podcastPlaybackPositionProvider = PodcastPlaybackPositionProvider._();

final class PodcastPlaybackPositionProvider
    extends
        $FunctionalProvider<AsyncValue<Duration>, Duration, Stream<Duration>>
    with $FutureModifier<Duration>, $StreamProvider<Duration> {
  PodcastPlaybackPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastPlaybackPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastPlaybackPositionHash();

  @$internal
  @override
  $StreamProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Duration> create(Ref ref) {
    return podcastPlaybackPosition(ref);
  }
}

String _$podcastPlaybackPositionHash() =>
    r'16dbcaa698addbf6da17ae7a41caf71524e396c1';

@ProviderFor(PodcastPlayerNotifier)
final podcastPlayerProvider = PodcastPlayerNotifierProvider._();

final class PodcastPlayerNotifierProvider
    extends $NotifierProvider<PodcastPlayerNotifier, PodcastPlayerState> {
  PodcastPlayerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastPlayerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastPlayerNotifierHash();

  @$internal
  @override
  PodcastPlayerNotifier create() => PodcastPlayerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodcastPlayerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodcastPlayerState>(value),
    );
  }
}

String _$podcastPlayerNotifierHash() =>
    r'6fcf9fed68135e6e8a3a8dbb7c472f2759f826e6';

abstract class _$PodcastPlayerNotifier extends $Notifier<PodcastPlayerState> {
  PodcastPlayerState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PodcastPlayerState, PodcastPlayerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PodcastPlayerState, PodcastPlayerState>,
              PodcastPlayerState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
