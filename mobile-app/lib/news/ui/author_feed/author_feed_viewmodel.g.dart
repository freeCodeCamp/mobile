// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_feed_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsAuthor)
final newsAuthorProvider = NewsAuthorFamily._();

final class NewsAuthorProvider
    extends $FunctionalProvider<AsyncValue<Author>, Author, FutureOr<Author>>
    with $FutureModifier<Author>, $FutureProvider<Author> {
  NewsAuthorProvider._({
    required NewsAuthorFamily super.from,
    required String super.argument,
  }) : super(
         retry: noRetry,
         name: r'newsAuthorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$newsAuthorHash();

  @override
  String toString() {
    return r'newsAuthorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Author> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Author> create(Ref ref) {
    final argument = this.argument as String;
    return newsAuthor(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NewsAuthorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$newsAuthorHash() => r'a5e18cbf5dfab5e401c017bcd113b00b719a1094';

final class NewsAuthorFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Author>, String> {
  NewsAuthorFamily._()
    : super(
        retry: noRetry,
        name: r'newsAuthorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NewsAuthorProvider call(String username) =>
      NewsAuthorProvider._(argument: username, from: this);

  @override
  String toString() => r'newsAuthorProvider';
}
