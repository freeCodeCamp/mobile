// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarks_controller.dart';

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
        retry: noRetry,
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
    r'94e2dd1a308e22870f1f7ca9265247f896335cb6';

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
