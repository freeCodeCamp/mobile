// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsFeedTags)
final newsFeedTagsProvider = NewsFeedTagsProvider._();

final class NewsFeedTagsProvider
    extends $FunctionalProvider<List<Tag>, List<Tag>, List<Tag>>
    with $Provider<List<Tag>> {
  NewsFeedTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsFeedTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsFeedTagsHash();

  @$internal
  @override
  $ProviderElement<List<Tag>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Tag> create(Ref ref) {
    return newsFeedTags(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Tag> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Tag>>(value),
    );
  }
}

String _$newsFeedTagsHash() => r'2ab1a0182d331907d0f0c86fc0768f79a4b92de2';

@ProviderFor(NewsSearchNotifier)
final newsSearchProvider = NewsSearchNotifierProvider._();

final class NewsSearchNotifierProvider
    extends
        $NotifierProvider<NewsSearchNotifier, AsyncValue<List<SearchPost>>> {
  NewsSearchNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'newsSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsSearchNotifierHash();

  @$internal
  @override
  NewsSearchNotifier create() => NewsSearchNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<SearchPost>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<SearchPost>>>(value),
    );
  }
}

String _$newsSearchNotifierHash() =>
    r'78c9277192ba4156b05f28e0d5aa6e615db9b8f7';

abstract class _$NewsSearchNotifier
    extends $Notifier<AsyncValue<List<SearchPost>>> {
  AsyncValue<List<SearchPost>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<SearchPost>>, AsyncValue<List<SearchPost>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SearchPost>>,
                AsyncValue<List<SearchPost>>
              >,
              AsyncValue<List<SearchPost>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
