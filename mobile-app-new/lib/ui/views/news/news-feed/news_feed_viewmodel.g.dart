// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_feed_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NewsFeedNotifier)
final newsFeedProvider = NewsFeedNotifierProvider._();

final class NewsFeedNotifierProvider
    extends $AsyncNotifierProvider<NewsFeedNotifier, List<Post>> {
  NewsFeedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsFeedNotifierHash();

  @$internal
  @override
  NewsFeedNotifier create() => NewsFeedNotifier();
}

String _$newsFeedNotifierHash() => r'486e9dc45f3b60e10877a8ae23ba66c77e15a65f';

abstract class _$NewsFeedNotifier extends $AsyncNotifier<List<Post>> {
  FutureOr<List<Post>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Post>>, List<Post>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Post>>, List<Post>>,
              AsyncValue<List<Post>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
