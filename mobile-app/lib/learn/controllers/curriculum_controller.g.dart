// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curriculum_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(curriculumStages)
final curriculumStagesProvider = CurriculumStagesProvider._();

final class CurriculumStagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CurriculumStage>>,
          List<CurriculumStage>,
          FutureOr<List<CurriculumStage>>
        >
    with
        $FutureModifier<List<CurriculumStage>>,
        $FutureProvider<List<CurriculumStage>> {
  CurriculumStagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'curriculumStagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$curriculumStagesHash();

  @$internal
  @override
  $FutureProviderElement<List<CurriculumStage>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CurriculumStage>> create(Ref ref) {
    return curriculumStages(ref);
  }
}

String _$curriculumStagesHash() => r'6be95266c53363ce05098ff83b205333640704d7';

@ProviderFor(superBlock)
final superBlockProvider = SuperBlockFamily._();

final class SuperBlockProvider
    extends
        $FunctionalProvider<
          AsyncValue<SuperBlock>,
          SuperBlock,
          FutureOr<SuperBlock>
        >
    with $FutureModifier<SuperBlock>, $FutureProvider<SuperBlock> {
  SuperBlockProvider._({
    required SuperBlockFamily super.from,
    required String super.argument,
  }) : super(
         retry: noRetry,
         name: r'superBlockProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$superBlockHash();

  @override
  String toString() {
    return r'superBlockProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SuperBlock> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<SuperBlock> create(Ref ref) {
    final argument = this.argument as String;
    return superBlock(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SuperBlockProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$superBlockHash() => r'18d2ae1f9b4aa3344d644a4cf7145368d680ff31';

final class SuperBlockFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SuperBlock>, String> {
  SuperBlockFamily._()
    : super(
        retry: noRetry,
        name: r'superBlockProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SuperBlockProvider call(String dashedName) =>
      SuperBlockProvider._(argument: dashedName, from: this);

  @override
  String toString() => r'superBlockProvider';
}
