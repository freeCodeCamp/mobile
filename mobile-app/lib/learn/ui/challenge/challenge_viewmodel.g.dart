// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(challengeScreen)
final challengeScreenProvider = ChallengeScreenFamily._();

final class ChallengeScreenProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChallengeScreenData>,
          ChallengeScreenData,
          FutureOr<ChallengeScreenData>
        >
    with
        $FutureModifier<ChallengeScreenData>,
        $FutureProvider<ChallengeScreenData> {
  ChallengeScreenProvider._({
    required ChallengeScreenFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'challengeScreenProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$challengeScreenHash();

  @override
  String toString() {
    return r'challengeScreenProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ChallengeScreenData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ChallengeScreenData> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return challengeScreen(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is ChallengeScreenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$challengeScreenHash() => r'aaa487fd4d644debd080b833ffb921d83db9fd1a';

final class ChallengeScreenFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ChallengeScreenData>,
          (String, String, String)
        > {
  ChallengeScreenFamily._()
    : super(
        retry: null,
        name: r'challengeScreenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChallengeScreenProvider call(
    String superBlock,
    String block,
    String challengeId,
  ) => ChallengeScreenProvider._(
    argument: (superBlock, block, challengeId),
    from: this,
  );

  @override
  String toString() => r'challengeScreenProvider';
}

@ProviderFor(ChallengeSubmitNotifier)
final challengeSubmitProvider = ChallengeSubmitNotifierFamily._();

final class ChallengeSubmitNotifierProvider
    extends $NotifierProvider<ChallengeSubmitNotifier, AsyncValue<void>> {
  ChallengeSubmitNotifierProvider._({
    required ChallengeSubmitNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'challengeSubmitProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$challengeSubmitNotifierHash();

  @override
  String toString() {
    return r'challengeSubmitProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChallengeSubmitNotifier create() => ChallengeSubmitNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChallengeSubmitNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$challengeSubmitNotifierHash() =>
    r'a6dcf728188587f269f0932576cf52b470aeb041';

final class ChallengeSubmitNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ChallengeSubmitNotifier,
          AsyncValue<void>,
          AsyncValue<void>,
          AsyncValue<void>,
          String
        > {
  ChallengeSubmitNotifierFamily._()
    : super(
        retry: null,
        name: r'challengeSubmitProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChallengeSubmitNotifierProvider call(String challengeId) =>
      ChallengeSubmitNotifierProvider._(argument: challengeId, from: this);

  @override
  String toString() => r'challengeSubmitProvider';
}

abstract class _$ChallengeSubmitNotifier extends $Notifier<AsyncValue<void>> {
  late final _$args = ref.$arg as String;
  String get challengeId => _$args;

  AsyncValue<void> build(String challengeId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
