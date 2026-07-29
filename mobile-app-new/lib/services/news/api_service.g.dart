// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsService)
final newsServiceProvider = NewsServiceProvider._();

final class NewsServiceProvider
    extends $FunctionalProvider<NewsService, NewsService, NewsService>
    with $Provider<NewsService> {
  NewsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsServiceHash();

  @$internal
  @override
  $ProviderElement<NewsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NewsService create(Ref ref) {
    return newsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewsService>(value),
    );
  }
}

String _$newsServiceHash() => r'bcc82311e3ebf3c546d6d05938b92d69e24bc6c9';
