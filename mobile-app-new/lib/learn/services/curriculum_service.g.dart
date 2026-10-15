// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curriculum_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnCurriculumService)
final learnCurriculumServiceProvider = LearnCurriculumServiceProvider._();

final class LearnCurriculumServiceProvider
    extends
        $FunctionalProvider<
          LearnCurriculumService,
          LearnCurriculumService,
          LearnCurriculumService
        >
    with $Provider<LearnCurriculumService> {
  LearnCurriculumServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnCurriculumServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnCurriculumServiceHash();

  @$internal
  @override
  $ProviderElement<LearnCurriculumService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearnCurriculumService create(Ref ref) {
    return learnCurriculumService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnCurriculumService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnCurriculumService>(value),
    );
  }
}

String _$learnCurriculumServiceHash() =>
    r'4d2cb5cb3589a54d6d867bd3fa48c7fb634e8d12';
