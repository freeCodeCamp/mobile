// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curriculum_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnCurriculumRepository)
final learnCurriculumRepositoryProvider = LearnCurriculumRepositoryProvider._();

final class LearnCurriculumRepositoryProvider
    extends
        $FunctionalProvider<
          LearnCurriculumRepository,
          LearnCurriculumRepository,
          LearnCurriculumRepository
        >
    with $Provider<LearnCurriculumRepository> {
  LearnCurriculumRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnCurriculumRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnCurriculumRepositoryHash();

  @$internal
  @override
  $ProviderElement<LearnCurriculumRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearnCurriculumRepository create(Ref ref) {
    return learnCurriculumRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnCurriculumRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnCurriculumRepository>(value),
    );
  }
}

String _$learnCurriculumRepositoryHash() =>
    r'c8bbb55b468c9158e97204e26db19a27b238d89d';
