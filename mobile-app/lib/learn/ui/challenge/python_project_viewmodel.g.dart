// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'python_project_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PythonProjectNotifier)
final pythonProjectProvider = PythonProjectNotifierFamily._();

final class PythonProjectNotifierProvider
    extends $NotifierProvider<PythonProjectNotifier, PythonProjectState> {
  PythonProjectNotifierProvider._({
    required PythonProjectNotifierFamily super.from,
    required Challenge super.argument,
  }) : super(
         retry: null,
         name: r'pythonProjectProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pythonProjectNotifierHash();

  @override
  String toString() {
    return r'pythonProjectProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PythonProjectNotifier create() => PythonProjectNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PythonProjectState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PythonProjectState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PythonProjectNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pythonProjectNotifierHash() =>
    r'8ea59301455ea3d66af2b3a561aa1451e359598d';

final class PythonProjectNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PythonProjectNotifier,
          PythonProjectState,
          PythonProjectState,
          PythonProjectState,
          Challenge
        > {
  PythonProjectNotifierFamily._()
    : super(
        retry: null,
        name: r'pythonProjectProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PythonProjectNotifierProvider call(Challenge challenge) =>
      PythonProjectNotifierProvider._(argument: challenge, from: this);

  @override
  String toString() => r'pythonProjectProvider';
}

abstract class _$PythonProjectNotifier extends $Notifier<PythonProjectState> {
  late final _$args = ref.$arg as Challenge;
  Challenge get challenge => _$args;

  PythonProjectState build(Challenge challenge);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PythonProjectState, PythonProjectState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PythonProjectState, PythonProjectState>,
              PythonProjectState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
