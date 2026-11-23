// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'english_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EnglishChallengeNotifier)
final englishChallengeProvider = EnglishChallengeNotifierFamily._();

final class EnglishChallengeNotifierProvider
    extends $NotifierProvider<EnglishChallengeNotifier, EnglishChallengeState> {
  EnglishChallengeNotifierProvider._({
    required EnglishChallengeNotifierFamily super.from,
    required Challenge super.argument,
  }) : super(
         retry: null,
         name: r'englishChallengeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$englishChallengeNotifierHash();

  @override
  String toString() {
    return r'englishChallengeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EnglishChallengeNotifier create() => EnglishChallengeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EnglishChallengeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EnglishChallengeState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EnglishChallengeNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$englishChallengeNotifierHash() =>
    r'284e7e8ee2261f33a30d6b384480eb0bb7ed00f1';

final class EnglishChallengeNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          EnglishChallengeNotifier,
          EnglishChallengeState,
          EnglishChallengeState,
          EnglishChallengeState,
          Challenge
        > {
  EnglishChallengeNotifierFamily._()
    : super(
        retry: null,
        name: r'englishChallengeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EnglishChallengeNotifierProvider call(Challenge challenge) =>
      EnglishChallengeNotifierProvider._(argument: challenge, from: this);

  @override
  String toString() => r'englishChallengeProvider';
}

abstract class _$EnglishChallengeNotifier
    extends $Notifier<EnglishChallengeState> {
  late final _$args = ref.$arg as Challenge;
  Challenge get challenge => _$args;

  EnglishChallengeState build(Challenge challenge);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EnglishChallengeState, EnglishChallengeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EnglishChallengeState, EnglishChallengeState>,
              EnglishChallengeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
