// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsApiService)
final newsApiServiceProvider = NewsApiServiceProvider._();

final class NewsApiServiceProvider
    extends $FunctionalProvider<NewsApiService, NewsApiService, NewsApiService>
    with $Provider<NewsApiService> {
  NewsApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsApiServiceHash();

  @$internal
  @override
  $ProviderElement<NewsApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NewsApiService create(Ref ref) {
    return newsApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewsApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewsApiService>(value),
    );
  }
}

String _$newsApiServiceHash() => r'551c870921b060fc2dd8d4f2ca644c0ad229615f';
