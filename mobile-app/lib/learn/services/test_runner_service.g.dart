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
        retry: noRetry,
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
    r'89c48950d65c444fb2a9b53fba87b1b79ea65a3c';

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
         retry: noRetry,
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
    r'fd8a905a211dccc0cee57f657ef4268f9996810d';

final class LearnTestRunnerServiceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LearnTestRunnerService>, String> {
  LearnTestRunnerServiceFamily._()
    : super(
        retry: noRetry,
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

@ProviderFor(learnTestRunnerSession)
final learnTestRunnerSessionProvider = LearnTestRunnerSessionFamily._();

final class LearnTestRunnerSessionProvider
    extends
        $FunctionalProvider<
          LearnTestRunnerSession,
          LearnTestRunnerSession,
          LearnTestRunnerSession
        >
    with $Provider<LearnTestRunnerSession> {
  LearnTestRunnerSessionProvider._({
    required LearnTestRunnerSessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'learnTestRunnerSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$learnTestRunnerSessionHash();

  @override
  String toString() {
    return r'learnTestRunnerSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<LearnTestRunnerSession> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearnTestRunnerSession create(Ref ref) {
    final argument = this.argument as String;
    return learnTestRunnerSession(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnTestRunnerSession value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnTestRunnerSession>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LearnTestRunnerSessionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$learnTestRunnerSessionHash() =>
    r'f8b8d08a6941fc742a087a2fb5634df415af99e8';

final class LearnTestRunnerSessionFamily extends $Family
    with $FunctionalFamilyOverride<LearnTestRunnerSession, String> {
  LearnTestRunnerSessionFamily._()
    : super(
        retry: null,
        name: r'learnTestRunnerSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LearnTestRunnerSessionProvider call(String challengeId) =>
      LearnTestRunnerSessionProvider._(argument: challengeId, from: this);

  @override
  String toString() => r'learnTestRunnerSessionProvider';
}
