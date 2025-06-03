// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pref.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Pref)
const prefProvider = PrefProvider._();

final class PrefProvider
    extends $AsyncNotifierProvider<Pref, SharedPreferences> {
  const PrefProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prefProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prefHash();

  @$internal
  @override
  Pref create() => Pref();

  @$internal
  @override
  $AsyncNotifierProviderElement<Pref, SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $AsyncNotifierProviderElement(pointer);
}

String _$prefHash() => r'85d3935b874dab33bc3e28690e7b9f2f9e80d389';

abstract class _$Pref extends $AsyncNotifier<SharedPreferences> {
  FutureOr<SharedPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<SharedPreferences>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SharedPreferences>>,
              AsyncValue<SharedPreferences>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
