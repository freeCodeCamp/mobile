// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LearningResumeNotifier)
final learningResumeProvider = LearningResumeNotifierProvider._();

final class LearningResumeNotifierProvider
    extends $AsyncNotifierProvider<LearningResumeNotifier, LearningResume?> {
  LearningResumeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'learningResumeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learningResumeNotifierHash();

  @$internal
  @override
  LearningResumeNotifier create() => LearningResumeNotifier();
}

String _$learningResumeNotifierHash() =>
    r'f002a26d1560a5b1e9249293035767c12ade77e7';

abstract class _$LearningResumeNotifier
    extends $AsyncNotifier<LearningResume?> {
  FutureOr<LearningResume?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LearningResume?>, LearningResume?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LearningResume?>, LearningResume?>,
              AsyncValue<LearningResume?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
