// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authSessionRepository)
final authSessionRepositoryProvider = AuthSessionRepositoryProvider._();

final class AuthSessionRepositoryProvider
    extends
        $FunctionalProvider<
          AuthSessionRepository,
          AuthSessionRepository,
          AuthSessionRepository
        >
    with $Provider<AuthSessionRepository> {
  AuthSessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthSessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthSessionRepository create(Ref ref) {
    return authSessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSessionRepository>(value),
    );
  }
}

String _$authSessionRepositoryHash() =>
    r'018e6ced2ad1e3e4b86be9c24717a7f147975f4c';
