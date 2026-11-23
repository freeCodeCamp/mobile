// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LessonChallengeNotifier)
final lessonChallengeProvider = LessonChallengeNotifierFamily._();

final class LessonChallengeNotifierProvider
    extends $NotifierProvider<LessonChallengeNotifier, LessonChallengeState> {
  LessonChallengeNotifierProvider._({
    required LessonChallengeNotifierFamily super.from,
    required Challenge super.argument,
  }) : super(
         retry: null,
         name: r'lessonChallengeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lessonChallengeNotifierHash();

  @override
  String toString() {
    return r'lessonChallengeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LessonChallengeNotifier create() => LessonChallengeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LessonChallengeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LessonChallengeState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LessonChallengeNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lessonChallengeNotifierHash() =>
    r'2474a01d69f4317cc5e5e57d7920af9b012c43b7';

final class LessonChallengeNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          LessonChallengeNotifier,
          LessonChallengeState,
          LessonChallengeState,
          LessonChallengeState,
          Challenge
        > {
  LessonChallengeNotifierFamily._()
    : super(
        retry: null,
        name: r'lessonChallengeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LessonChallengeNotifierProvider call(Challenge challenge) =>
      LessonChallengeNotifierProvider._(argument: challenge, from: this);

  @override
  String toString() => r'lessonChallengeProvider';
}

abstract class _$LessonChallengeNotifier
    extends $Notifier<LessonChallengeState> {
  late final _$args = ref.$arg as Challenge;
  Challenge get challenge => _$args;

  LessonChallengeState build(Challenge challenge);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LessonChallengeState, LessonChallengeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LessonChallengeState, LessonChallengeState>,
              LessonChallengeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
