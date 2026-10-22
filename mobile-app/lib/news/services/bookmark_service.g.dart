// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsBookmarkService)
final newsBookmarkServiceProvider = NewsBookmarkServiceProvider._();

final class NewsBookmarkServiceProvider
    extends
        $FunctionalProvider<
          NewsBookmarkService,
          NewsBookmarkService,
          NewsBookmarkService
        >
    with $Provider<NewsBookmarkService> {
  NewsBookmarkServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsBookmarkServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsBookmarkServiceHash();

  @$internal
  @override
  $ProviderElement<NewsBookmarkService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NewsBookmarkService create(Ref ref) {
    return newsBookmarkService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewsBookmarkService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewsBookmarkService>(value),
    );
  }
}

String _$newsBookmarkServiceHash() =>
    r'dddde915bacf3c8e3780ae1b81dd9f6675b63b06';
