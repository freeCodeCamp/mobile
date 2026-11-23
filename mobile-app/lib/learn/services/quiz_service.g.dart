// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnQuizService)
final learnQuizServiceProvider = LearnQuizServiceProvider._();

final class LearnQuizServiceProvider
    extends
        $FunctionalProvider<
          LearnQuizService,
          LearnQuizService,
          LearnQuizService
        >
    with $Provider<LearnQuizService> {
  LearnQuizServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnQuizServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnQuizServiceHash();

  @$internal
  @override
  $ProviderElement<LearnQuizService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LearnQuizService create(Ref ref) {
    return learnQuizService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnQuizService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnQuizService>(value),
    );
  }
}

String _$learnQuizServiceHash() => r'224f12da01c85adea64c33bcb1464fc6422a81f3';
