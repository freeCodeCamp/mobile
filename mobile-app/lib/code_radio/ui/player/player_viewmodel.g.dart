// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CodeRadioPlayerNotifier)
final codeRadioPlayerProvider = CodeRadioPlayerNotifierProvider._();

final class CodeRadioPlayerNotifierProvider
    extends $NotifierProvider<CodeRadioPlayerNotifier, bool> {
  CodeRadioPlayerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codeRadioPlayerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codeRadioPlayerNotifierHash();

  @$internal
  @override
  CodeRadioPlayerNotifier create() => CodeRadioPlayerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$codeRadioPlayerNotifierHash() =>
    r'59fd398f9e0ce56c771f53653143fc4ff054dc13';

abstract class _$CodeRadioPlayerNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
