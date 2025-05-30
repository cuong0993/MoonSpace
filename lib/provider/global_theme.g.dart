// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_theme.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(GlobalTheme)
const globalThemeProvider = GlobalThemeProvider._();

final class GlobalThemeProvider
    extends $NotifierProvider<GlobalTheme, GlobalAppTheme> {
  const GlobalThemeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'globalThemeProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$globalThemeHash();

  @$internal
  @override
  GlobalTheme create() => GlobalTheme();

  @$internal
  @override
  $NotifierProviderElement<GlobalTheme, GlobalAppTheme> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalAppTheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<GlobalAppTheme>(value),
    );
  }
}

String _$globalThemeHash() => r'cb60d81d0307874c0905f80fd5142f91143d8ea4';

abstract class _$GlobalTheme extends $Notifier<GlobalAppTheme> {
  GlobalAppTheme build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GlobalAppTheme>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<GlobalAppTheme>, GlobalAppTheme, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
