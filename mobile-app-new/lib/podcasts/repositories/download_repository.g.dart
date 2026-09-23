// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(podcastDownloadRepository)
final podcastDownloadRepositoryProvider = PodcastDownloadRepositoryProvider._();

final class PodcastDownloadRepositoryProvider
    extends
        $FunctionalProvider<
          PodcastDownloadRepository,
          PodcastDownloadRepository,
          PodcastDownloadRepository
        >
    with $Provider<PodcastDownloadRepository> {
  PodcastDownloadRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastDownloadRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastDownloadRepositoryHash();

  @$internal
  @override
  $ProviderElement<PodcastDownloadRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PodcastDownloadRepository create(Ref ref) {
    return podcastDownloadRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodcastDownloadRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodcastDownloadRepository>(value),
    );
  }
}

String _$podcastDownloadRepositoryHash() =>
    r'15405ac28c4d7d71680f781d534431e409120a6b';
