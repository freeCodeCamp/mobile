// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsSearchService)
final newsSearchServiceProvider = NewsSearchServiceProvider._();

final class NewsSearchServiceProvider
    extends
        $FunctionalProvider<
          NewsSearchService,
          NewsSearchService,
          NewsSearchService
        >
    with $Provider<NewsSearchService> {
  NewsSearchServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'newsSearchServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsSearchServiceHash();

  @$internal
  @override
  $ProviderElement<NewsSearchService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NewsSearchService create(Ref ref) {
    return newsSearchService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewsSearchService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewsSearchService>(value),
    );
  }
}

String _$newsSearchServiceHash() => r'5b7f02d839edd42c30b74378a8545e54814a96bb';
