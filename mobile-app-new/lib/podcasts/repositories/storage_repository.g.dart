// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(podcastStorageRepository)
final podcastStorageRepositoryProvider = PodcastStorageRepositoryProvider._();

final class PodcastStorageRepositoryProvider
    extends
        $FunctionalProvider<
          PodcastStorageRepository,
          PodcastStorageRepository,
          PodcastStorageRepository
        >
    with $Provider<PodcastStorageRepository> {
  PodcastStorageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastStorageRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastStorageRepositoryHash();

  @$internal
  @override
  $ProviderElement<PodcastStorageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PodcastStorageRepository create(Ref ref) {
    return podcastStorageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodcastStorageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodcastStorageRepository>(value),
    );
  }
}

String _$podcastStorageRepositoryHash() =>
    r'bda3ac43ee0a8ebfa3993c374904e090669f8d59';
