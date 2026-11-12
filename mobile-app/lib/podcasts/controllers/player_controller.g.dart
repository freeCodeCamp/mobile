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

@ProviderFor(podcastSavedPosition)
final podcastSavedPositionProvider = PodcastSavedPositionFamily._();

final class PodcastSavedPositionProvider
    extends $FunctionalProvider<Duration?, Duration?, Duration?>
    with $Provider<Duration?> {
  PodcastSavedPositionProvider._({
    required PodcastSavedPositionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'podcastSavedPositionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$podcastSavedPositionHash();

  @override
  String toString() {
    return r'podcastSavedPositionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Duration?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration? create(Ref ref) {
    final argument = this.argument as String;
    return podcastSavedPosition(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PodcastSavedPositionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podcastSavedPositionHash() =>
    r'435b5a5d219da9904fc359137bbb706291f231fb';

final class PodcastSavedPositionFamily extends $Family
    with $FunctionalFamilyOverride<Duration?, String> {
  PodcastSavedPositionFamily._()
    : super(
        retry: null,
        name: r'podcastSavedPositionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PodcastSavedPositionProvider call(String episodeId) =>
      PodcastSavedPositionProvider._(argument: episodeId, from: this);

  @override
  String toString() => r'podcastSavedPositionProvider';
}

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
    r'925ddafb8e944c707e79cbc12bcb96000be75937';

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
