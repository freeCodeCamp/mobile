// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_feed_list_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NewsFeedNotifier)
final newsFeedProvider = NewsFeedNotifierFamily._();

final class NewsFeedNotifierProvider
    extends $AsyncNotifierProvider<NewsFeedNotifier, List<Post>> {
  NewsFeedNotifierProvider._({
    required NewsFeedNotifierFamily super.from,
    required String super.argument,
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
        '($argument)';
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

String _$newsFeedNotifierHash() => r'8a9c5876f06d573366cae016d2d97e3aba37584b';

final class NewsFeedNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          NewsFeedNotifier,
          AsyncValue<List<Post>>,
          List<Post>,
          FutureOr<List<Post>>,
          String
        > {
  NewsFeedNotifierFamily._()
    : super(
        retry: null,
        name: r'newsFeedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NewsFeedNotifierProvider call({String tagSlug = ''}) =>
      NewsFeedNotifierProvider._(argument: tagSlug, from: this);

  @override
  String toString() => r'newsFeedProvider';
}

abstract class _$NewsFeedNotifier extends $AsyncNotifier<List<Post>> {
  late final _$args = ref.$arg as String;
  String get tagSlug => _$args;

  FutureOr<List<Post>> build({String tagSlug = ''});
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
    return element.handleCreate(ref, () => build(tagSlug: _$args));
  }
}
