// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(podcastLibraryService)
final podcastLibraryServiceProvider = PodcastLibraryServiceProvider._();

final class PodcastLibraryServiceProvider
    extends
        $FunctionalProvider<
          PodcastLibraryService,
          PodcastLibraryService,
          PodcastLibraryService
        >
    with $Provider<PodcastLibraryService> {
  PodcastLibraryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastLibraryServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastLibraryServiceHash();

  @$internal
  @override
  $ProviderElement<PodcastLibraryService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PodcastLibraryService create(Ref ref) {
    return podcastLibraryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodcastLibraryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodcastLibraryService>(value),
    );
  }
}

String _$podcastLibraryServiceHash() =>
    r'aea6f426a719db3df28934b955b43ca51c7c041d';
