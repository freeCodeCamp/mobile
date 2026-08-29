// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_bookmark_feed_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NewsBookmarksNotifier)
final newsBookmarksProvider = NewsBookmarksNotifierProvider._();

final class NewsBookmarksNotifierProvider
    extends
        $AsyncNotifierProvider<NewsBookmarksNotifier, List<BookmarkedPost>> {
  NewsBookmarksNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsBookmarksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsBookmarksNotifierHash();

  @$internal
  @override
  NewsBookmarksNotifier create() => NewsBookmarksNotifier();
}

String _$newsBookmarksNotifierHash() =>
    r'48e14a8a3b117cf8bbb8e9de2dcd446c95162b56';

abstract class _$NewsBookmarksNotifier
    extends $AsyncNotifier<List<BookmarkedPost>> {
  FutureOr<List<BookmarkedPost>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<BookmarkedPost>>, List<BookmarkedPost>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<BookmarkedPost>>,
                List<BookmarkedPost>
              >,
              AsyncValue<List<BookmarkedPost>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
