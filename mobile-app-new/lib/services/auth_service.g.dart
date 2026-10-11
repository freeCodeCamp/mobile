// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

final class AuthNotifierProvider
    extends $AsyncNotifierProvider<AuthNotifier, FccUserModel?> {
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();
}

String _$authNotifierHash() => r'8a83aa80bb58addb8d06a66c4d893a193e3734a3';

abstract class _$AuthNotifier extends $AsyncNotifier<FccUserModel?> {
  FutureOr<FccUserModel?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<FccUserModel?>, FccUserModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FccUserModel?>, FccUserModel?>,
              AsyncValue<FccUserModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
