// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authSessionService)
final authSessionServiceProvider = AuthSessionServiceProvider._();

final class AuthSessionServiceProvider
    extends
        $FunctionalProvider<
          AuthSessionService,
          AuthSessionService,
          AuthSessionService
        >
    with $Provider<AuthSessionService> {
  AuthSessionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionServiceHash();

  @$internal
  @override
  $ProviderElement<AuthSessionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthSessionService create(Ref ref) {
    return authSessionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSessionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSessionService>(value),
    );
  }
}

String _$authSessionServiceHash() =>
    r'93398023ee6246232909b212abf32acc5cbf42ba';
