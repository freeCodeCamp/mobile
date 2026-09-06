// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsPost)
final newsPostProvider = NewsPostFamily._();

final class NewsPostProvider
    extends $FunctionalProvider<AsyncValue<Post>, Post, FutureOr<Post>>
    with $FutureModifier<Post>, $FutureProvider<Post> {
  NewsPostProvider._({
    required NewsPostFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'newsPostProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$newsPostHash();

  @override
  String toString() {
    return r'newsPostProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Post> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Post> create(Ref ref) {
    final argument = this.argument as String;
    return newsPost(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NewsPostProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$newsPostHash() => r'26d73110a1b22400e8030d5543a43f78104a83f3';

final class NewsPostFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Post>, String> {
  NewsPostFamily._()
    : super(
        retry: null,
        name: r'newsPostProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NewsPostProvider call(String slug) =>
      NewsPostProvider._(argument: slug, from: this);

  @override
  String toString() => r'newsPostProvider';
}
