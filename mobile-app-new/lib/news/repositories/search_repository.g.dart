// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsSearchRepository)
final newsSearchRepositoryProvider = NewsSearchRepositoryProvider._();

final class NewsSearchRepositoryProvider
    extends
        $FunctionalProvider<
          NewsSearchRepository,
          NewsSearchRepository,
          NewsSearchRepository
        >
    with $Provider<NewsSearchRepository> {
  NewsSearchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsSearchRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsSearchRepositoryHash();

  @$internal
  @override
  $ProviderElement<NewsSearchRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NewsSearchRepository create(Ref ref) {
    return newsSearchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewsSearchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewsSearchRepository>(value),
    );
  }
}

String _$newsSearchRepositoryHash() =>
    r'e98a8d3f4250ccf351e79082c1d019c6bf48bf27';
