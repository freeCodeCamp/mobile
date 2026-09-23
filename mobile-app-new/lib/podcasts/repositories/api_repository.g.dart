// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(podcastApiRepository)
final podcastApiRepositoryProvider = PodcastApiRepositoryProvider._();

final class PodcastApiRepositoryProvider
    extends
        $FunctionalProvider<
          PodcastApiRepository,
          PodcastApiRepository,
          PodcastApiRepository
        >
    with $Provider<PodcastApiRepository> {
  PodcastApiRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastApiRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastApiRepositoryHash();

  @$internal
  @override
  $ProviderElement<PodcastApiRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PodcastApiRepository create(Ref ref) {
    return podcastApiRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodcastApiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodcastApiRepository>(value),
    );
  }
}

String _$podcastApiRepositoryHash() =>
    r'7ccb4cf53f8bcdf719d87a236334120d5405afa9';
