// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuizNotifier)
final quizProvider = QuizNotifierFamily._();

final class QuizNotifierProvider
    extends $NotifierProvider<QuizNotifier, QuizState> {
  QuizNotifierProvider._({
    required QuizNotifierFamily super.from,
    required Challenge super.argument,
  }) : super(
         retry: null,
         name: r'quizProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$quizNotifierHash();

  @override
  String toString() {
    return r'quizProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  QuizNotifier create() => QuizNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuizState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuizState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is QuizNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$quizNotifierHash() => r'73d7018098e446b8f7b204426643c6d6ef25aaf1';

final class QuizNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          QuizNotifier,
          QuizState,
          QuizState,
          QuizState,
          Challenge
        > {
  QuizNotifierFamily._()
    : super(
        retry: null,
        name: r'quizProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QuizNotifierProvider call(Challenge challenge) =>
      QuizNotifierProvider._(argument: challenge, from: this);

  @override
  String toString() => r'quizProvider';
}

abstract class _$QuizNotifier extends $Notifier<QuizState> {
  late final _$args = ref.$arg as Challenge;
  Challenge get challenge => _$args;

  QuizState build(Challenge challenge);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<QuizState, QuizState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QuizState, QuizState>,
              QuizState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
