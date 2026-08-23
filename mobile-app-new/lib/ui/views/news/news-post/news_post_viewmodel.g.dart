// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_post_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NewsPostNotifier)
final newsPostProvider = NewsPostNotifierFamily._();

final class NewsPostNotifierProvider
    extends $AsyncNotifierProvider<NewsPostNotifier, Post> {
  NewsPostNotifierProvider._({
    required NewsPostNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'newsPostProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$newsPostNotifierHash();

  @override
  String toString() {
    return r'newsPostProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NewsPostNotifier create() => NewsPostNotifier();

  @override
  bool operator ==(Object other) {
    return other is NewsPostNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$newsPostNotifierHash() => r'4bd3a49efc3dc02afdc6162c81e9c16f333ef143';

final class NewsPostNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          NewsPostNotifier,
          AsyncValue<Post>,
          Post,
          FutureOr<Post>,
          String
        > {
  NewsPostNotifierFamily._()
    : super(
        retry: null,
        name: r'newsPostProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NewsPostNotifierProvider call(String slug) =>
      NewsPostNotifierProvider._(argument: slug, from: this);

  @override
  String toString() => r'newsPostProvider';
}

abstract class _$NewsPostNotifier extends $AsyncNotifier<Post> {
  late final _$args = ref.$arg as String;
  String get slug => _$args;

  FutureOr<Post> build(String slug);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Post>, Post>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Post>, Post>,
              AsyncValue<Post>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
