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
        retry: null,
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

String _$curriculumStagesHash() => r'4deed0b888f89433b7f5847f63d049a50644e201';

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
         retry: null,
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

String _$superBlockHash() => r'5d5a095729fd2638b80918c93fe6411e6cc4a53f';

final class SuperBlockFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SuperBlock>, String> {
  SuperBlockFamily._()
    : super(
        retry: null,
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
