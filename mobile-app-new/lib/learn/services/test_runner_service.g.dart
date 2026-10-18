// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_runner_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnTestRunnerServer)
final learnTestRunnerServerProvider = LearnTestRunnerServerProvider._();

final class LearnTestRunnerServerProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  LearnTestRunnerServerProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'learnTestRunnerServerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnTestRunnerServerHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return learnTestRunnerServer(ref);
  }
}

String _$learnTestRunnerServerHash() =>
    r'fd6d1be88aeb26dbd82b68fa7f988ff07db6bae6';

@ProviderFor(learnTestRunnerService)
final learnTestRunnerServiceProvider = LearnTestRunnerServiceFamily._();

final class LearnTestRunnerServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<LearnTestRunnerService>,
          LearnTestRunnerService,
          FutureOr<LearnTestRunnerService>
        >
    with
        $FutureModifier<LearnTestRunnerService>,
        $FutureProvider<LearnTestRunnerService> {
  LearnTestRunnerServiceProvider._({
    required LearnTestRunnerServiceFamily super.from,
    required String super.argument,
  }) : super(
         retry: _noRetry,
         name: r'learnTestRunnerServiceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$learnTestRunnerServiceHash();

  @override
  String toString() {
    return r'learnTestRunnerServiceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LearnTestRunnerService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LearnTestRunnerService> create(Ref ref) {
    final argument = this.argument as String;
    return learnTestRunnerService(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LearnTestRunnerServiceProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$learnTestRunnerServiceHash() =>
    r'12356eb790c0604aa12d884a47f031b614b9a61d';

final class LearnTestRunnerServiceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LearnTestRunnerService>, String> {
  LearnTestRunnerServiceFamily._()
    : super(
        retry: _noRetry,
        name: r'learnTestRunnerServiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LearnTestRunnerServiceProvider call(String workerType) =>
      LearnTestRunnerServiceProvider._(argument: workerType, from: this);

  @override
  String toString() => r'learnTestRunnerServiceProvider';
}
