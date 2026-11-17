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
        retry: noRetry,
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

String _$authNotifierHash() => r'3a282c74b4cb6c44d11716ec599f4a5f1d171c22';

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
