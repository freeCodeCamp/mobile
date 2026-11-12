// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppPreferencesNotifier)
final appPreferencesProvider = AppPreferencesNotifierProvider._();

final class AppPreferencesNotifierProvider
    extends $AsyncNotifierProvider<AppPreferencesNotifier, AppPreferences> {
  AppPreferencesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'appPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPreferencesNotifierHash();

  @$internal
  @override
  AppPreferencesNotifier create() => AppPreferencesNotifier();
}

String _$appPreferencesNotifierHash() =>
    r'87ec724ec45e9490e829a18dc514024d31d41cf4';

abstract class _$AppPreferencesNotifier extends $AsyncNotifier<AppPreferences> {
  FutureOr<AppPreferences> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppPreferences>, AppPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppPreferences>, AppPreferences>,
              AsyncValue<AppPreferences>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
