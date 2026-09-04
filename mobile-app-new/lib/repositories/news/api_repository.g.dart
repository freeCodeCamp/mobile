// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsApiRepository)
final newsApiRepositoryProvider = NewsApiRepositoryProvider._();

final class NewsApiRepositoryProvider
    extends
        $FunctionalProvider<
          NewsApiRepository,
          NewsApiRepository,
          NewsApiRepository
        >
    with $Provider<NewsApiRepository> {
  NewsApiRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsApiRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsApiRepositoryHash();

  @$internal
  @override
  $ProviderElement<NewsApiRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NewsApiRepository create(Ref ref) {
    return newsApiRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewsApiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewsApiRepository>(value),
    );
  }
}

String _$newsApiRepositoryHash() => r'c2ab6b0169b271263c24f15aee897d85018bbeda';
