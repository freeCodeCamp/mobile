// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsBookmarkRepository)
final newsBookmarkRepositoryProvider = NewsBookmarkRepositoryProvider._();

final class NewsBookmarkRepositoryProvider
    extends
        $FunctionalProvider<
          NewsBookmarkRepository,
          NewsBookmarkRepository,
          NewsBookmarkRepository
        >
    with $Provider<NewsBookmarkRepository> {
  NewsBookmarkRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsBookmarkRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsBookmarkRepositoryHash();

  @$internal
  @override
  $ProviderElement<NewsBookmarkRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NewsBookmarkRepository create(Ref ref) {
    return newsBookmarkRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewsBookmarkRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewsBookmarkRepository>(value),
    );
  }
}

String _$newsBookmarkRepositoryHash() =>
    r'26f6e95a45517cb80b2397d773582152a38e58f2';
