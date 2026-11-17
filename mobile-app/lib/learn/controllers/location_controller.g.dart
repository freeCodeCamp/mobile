// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LearningLocationNotifier)
final learningLocationProvider = LearningLocationNotifierFamily._();

final class LearningLocationNotifierProvider
    extends $AsyncNotifierProvider<LearningLocationNotifier, LearnLocation?> {
  LearningLocationNotifierProvider._({
    required LearningLocationNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'learningLocationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$learningLocationNotifierHash();

  @override
  String toString() {
    return r'learningLocationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LearningLocationNotifier create() => LearningLocationNotifier();

  @override
  bool operator ==(Object other) {
    return other is LearningLocationNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$learningLocationNotifierHash() =>
    r'a49751b70605580167cfa49842a78388df65dd9f';

final class LearningLocationNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          LearningLocationNotifier,
          AsyncValue<LearnLocation?>,
          LearnLocation?,
          FutureOr<LearnLocation?>,
          String
        > {
  LearningLocationNotifierFamily._()
    : super(
        retry: null,
        name: r'learningLocationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LearningLocationNotifierProvider call(String userId) =>
      LearningLocationNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'learningLocationProvider';
}

abstract class _$LearningLocationNotifier
    extends $AsyncNotifier<LearnLocation?> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<LearnLocation?> build(String userId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LearnLocation?>, LearnLocation?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LearnLocation?>, LearnLocation?>,
              AsyncValue<LearnLocation?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
