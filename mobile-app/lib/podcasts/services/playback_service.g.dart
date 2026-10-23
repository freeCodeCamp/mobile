// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(podcastPlaybackService)
final podcastPlaybackServiceProvider = PodcastPlaybackServiceProvider._();

final class PodcastPlaybackServiceProvider
    extends
        $FunctionalProvider<
          PodcastPlaybackService,
          PodcastPlaybackService,
          PodcastPlaybackService
        >
    with $Provider<PodcastPlaybackService> {
  PodcastPlaybackServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastPlaybackServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastPlaybackServiceHash();

  @$internal
  @override
  $ProviderElement<PodcastPlaybackService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PodcastPlaybackService create(Ref ref) {
    return podcastPlaybackService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodcastPlaybackService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodcastPlaybackService>(value),
    );
  }
}

String _$podcastPlaybackServiceHash() =>
    r'fdba54b5176077af6f9dafafb320aa44c3ef7223';
