// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(codeRadioWebsocketRepository)
final codeRadioWebsocketRepositoryProvider =
    CodeRadioWebsocketRepositoryProvider._();

final class CodeRadioWebsocketRepositoryProvider
    extends
        $FunctionalProvider<
          CodeRadioWebsocketRepository,
          CodeRadioWebsocketRepository,
          CodeRadioWebsocketRepository
        >
    with $Provider<CodeRadioWebsocketRepository> {
  CodeRadioWebsocketRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codeRadioWebsocketRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codeRadioWebsocketRepositoryHash();

  @$internal
  @override
  $ProviderElement<CodeRadioWebsocketRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CodeRadioWebsocketRepository create(Ref ref) {
    return codeRadioWebsocketRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CodeRadioWebsocketRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CodeRadioWebsocketRepository>(value),
    );
  }
}

String _$codeRadioWebsocketRepositoryHash() =>
    r'6ba28b15535756ff4a682f6e08c0e301f3c47732';
