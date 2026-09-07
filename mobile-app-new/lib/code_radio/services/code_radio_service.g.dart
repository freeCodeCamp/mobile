// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_radio_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(codeRadioService)
final codeRadioServiceProvider = CodeRadioServiceProvider._();

final class CodeRadioServiceProvider
    extends
        $FunctionalProvider<
          CodeRadioService,
          CodeRadioService,
          CodeRadioService
        >
    with $Provider<CodeRadioService> {
  CodeRadioServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codeRadioServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codeRadioServiceHash();

  @$internal
  @override
  $ProviderElement<CodeRadioService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CodeRadioService create(Ref ref) {
    return codeRadioService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CodeRadioService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CodeRadioService>(value),
    );
  }
}

String _$codeRadioServiceHash() => r'9ce102b6a6ce4ebc4977914b53276ec06277646a';
