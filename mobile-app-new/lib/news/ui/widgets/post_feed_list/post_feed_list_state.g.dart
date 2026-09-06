// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_feed_list_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NewsFeedNotifier)
final newsFeedProvider = NewsFeedNotifierFamily._();

final class NewsFeedNotifierProvider
    extends $AsyncNotifierProvider<NewsFeedNotifier, NewsFeedState> {
  NewsFeedNotifierProvider._({
    required NewsFeedNotifierFamily super.from,
    required ({String tagSlug, String authorId}) super.argument,
  }) : super(
         retry: null,
         name: r'newsFeedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$newsFeedNotifierHash();

  @override
  String toString() {
    return r'newsFeedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  NewsFeedNotifier create() => NewsFeedNotifier();

  @override
  bool operator ==(Object other) {
    return other is NewsFeedNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$newsFeedNotifierHash() => r'b995464eda0195451d0942e58f38d176e44c7e34';

final class NewsFeedNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          NewsFeedNotifier,
          AsyncValue<NewsFeedState>,
          NewsFeedState,
          FutureOr<NewsFeedState>,
          ({String tagSlug, String authorId})
        > {
  NewsFeedNotifierFamily._()
    : super(
        retry: null,
        name: r'newsFeedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NewsFeedNotifierProvider call({String tagSlug = '', String authorId = ''}) =>
      NewsFeedNotifierProvider._(
        argument: (tagSlug: tagSlug, authorId: authorId),
        from: this,
      );

  @override
  String toString() => r'newsFeedProvider';
}

abstract class _$NewsFeedNotifier extends $AsyncNotifier<NewsFeedState> {
  late final _$args = ref.$arg as ({String tagSlug, String authorId});
  String get tagSlug => _$args.tagSlug;
  String get authorId => _$args.authorId;

  FutureOr<NewsFeedState> build({String tagSlug = '', String authorId = ''});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<NewsFeedState>, NewsFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NewsFeedState>, NewsFeedState>,
              AsyncValue<NewsFeedState>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(tagSlug: _$args.tagSlug, authorId: _$args.authorId),
    );
  }
}
