// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_player_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MediaPlayerNotifier)
final mediaPlayerProvider = MediaPlayerNotifierProvider._();

final class MediaPlayerNotifierProvider
    extends $NotifierProvider<MediaPlayerNotifier, MediaPlayerState> {
  MediaPlayerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaPlayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaPlayerNotifierHash();

  @$internal
  @override
  MediaPlayerNotifier create() => MediaPlayerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaPlayerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaPlayerState>(value),
    );
  }
}

String _$mediaPlayerNotifierHash() =>
    r'4e23f4727cc4c6eca3aad32a021b0aca64d1c414';

abstract class _$MediaPlayerNotifier extends $Notifier<MediaPlayerState> {
  MediaPlayerState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MediaPlayerState, MediaPlayerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MediaPlayerState, MediaPlayerState>,
              MediaPlayerState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
