// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editor_challenge_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(passQuote)
final passQuoteProvider = PassQuoteProvider._();

final class PassQuoteProvider
    extends
        $FunctionalProvider<
          AsyncValue<MotivationalQuote>,
          MotivationalQuote,
          FutureOr<MotivationalQuote>
        >
    with
        $FutureModifier<MotivationalQuote>,
        $FutureProvider<MotivationalQuote> {
  PassQuoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passQuoteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passQuoteHash();

  @$internal
  @override
  $FutureProviderElement<MotivationalQuote> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MotivationalQuote> create(Ref ref) {
    return passQuote(ref);
  }
}

String _$passQuoteHash() => r'2426ee6b188c091b647d44fef731607ef8cbd83e';

@ProviderFor(EditorChallengeNotifier)
final editorChallengeProvider = EditorChallengeNotifierFamily._();

final class EditorChallengeNotifierProvider
    extends $NotifierProvider<EditorChallengeNotifier, EditorChallengeState> {
  EditorChallengeNotifierProvider._({
    required EditorChallengeNotifierFamily super.from,
    required Challenge super.argument,
  }) : super(
         retry: null,
         name: r'editorChallengeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editorChallengeNotifierHash();

  @override
  String toString() {
    return r'editorChallengeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditorChallengeNotifier create() => EditorChallengeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EditorChallengeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EditorChallengeState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EditorChallengeNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editorChallengeNotifierHash() =>
    r'5df8936a7c0542b4af02e5722ce7db1f0f00b7f8';

final class EditorChallengeNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          EditorChallengeNotifier,
          EditorChallengeState,
          EditorChallengeState,
          EditorChallengeState,
          Challenge
        > {
  EditorChallengeNotifierFamily._()
    : super(
        retry: null,
        name: r'editorChallengeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EditorChallengeNotifierProvider call(Challenge challenge) =>
      EditorChallengeNotifierProvider._(argument: challenge, from: this);

  @override
  String toString() => r'editorChallengeProvider';
}

abstract class _$EditorChallengeNotifier
    extends $Notifier<EditorChallengeState> {
  late final _$args = ref.$arg as Challenge;
  Challenge get challenge => _$args;

  EditorChallengeState build(Challenge challenge);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EditorChallengeState, EditorChallengeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EditorChallengeState, EditorChallengeState>,
              EditorChallengeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
