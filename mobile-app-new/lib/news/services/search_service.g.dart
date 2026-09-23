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
        retry: null,
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

String _$newsSearchServiceHash() => r'7bc8728f9bbde4042a5f3511d86f59729a5e8074';
