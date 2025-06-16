// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rankone.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(games)
const gamesProvider = GamesProvider._();

final class GamesProvider
    extends $FunctionalProvider<AsyncValue<List<Game>>, FutureOr<List<Game>>>
    with $FutureModifier<List<Game>>, $FutureProvider<List<Game>> {
  const GamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gamesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gamesHash();

  @$internal
  @override
  $FutureProviderElement<List<Game>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Game>> create(Ref ref) {
    return games(ref);
  }
}

String _$gamesHash() => r'2bfe4153da248c68ab9e73bcd5088d28f6bac3b8';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
