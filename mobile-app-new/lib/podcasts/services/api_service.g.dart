// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(podcastApiService)
final podcastApiServiceProvider = PodcastApiServiceProvider._();

final class PodcastApiServiceProvider
    extends
        $FunctionalProvider<
          PodcastApiService,
          PodcastApiService,
          PodcastApiService
        >
    with $Provider<PodcastApiService> {
  PodcastApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastApiServiceHash();

  @$internal
  @override
  $ProviderElement<PodcastApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PodcastApiService create(Ref ref) {
    return podcastApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodcastApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodcastApiService>(value),
    );
  }
}

String _$podcastApiServiceHash() => r'b94a43282e9a2601f8863cbf964d9f7bbd827535';
