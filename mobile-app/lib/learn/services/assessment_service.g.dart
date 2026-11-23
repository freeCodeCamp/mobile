// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnAssessmentService)
final learnAssessmentServiceProvider = LearnAssessmentServiceProvider._();

final class LearnAssessmentServiceProvider
    extends
        $FunctionalProvider<
          LearnAssessmentService,
          LearnAssessmentService,
          LearnAssessmentService
        >
    with $Provider<LearnAssessmentService> {
  LearnAssessmentServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnAssessmentServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnAssessmentServiceHash();

  @$internal
  @override
  $ProviderElement<LearnAssessmentService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearnAssessmentService create(Ref ref) {
    return learnAssessmentService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnAssessmentService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnAssessmentService>(value),
    );
  }
}

String _$learnAssessmentServiceHash() =>
    r'5111475be56c73ea21bc515ec493a3d8bd74eed1';
