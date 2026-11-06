// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
