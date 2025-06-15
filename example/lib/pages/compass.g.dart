// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compass.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$rootRoute];

RouteBase get $rootRoute => GoRouteData.$route(
  path: '/compass',

  factory: _$RootRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'countries',

      factory: _$CountriesRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: ':country',

          factory: _$CountryRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: '/activities',

              factory: _$ActivitiesRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    GoRouteData.$route(
      path: 'destinations-list',

      factory: _$DestinationListRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'activities-list',

      factory: _$ActivityListRoute._fromState,
    ),
  ],
);

mixin _$RootRoute on GoRouteData {
  static RootRoute _fromState(GoRouterState state) => const RootRoute();

  @override
  String get location => GoRouteData.$location('/compass');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$CountriesRoute on GoRouteData {
  static CountriesRoute _fromState(GoRouterState state) =>
      const CountriesRoute();

  @override
  String get location => GoRouteData.$location('/compass/countries');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$CountryRoute on GoRouteData {
  static CountryRoute _fromState(GoRouterState state) =>
      CountryRoute(state.pathParameters['country']!);

  CountryRoute get _self => this as CountryRoute;

  @override
  String get location => GoRouteData.$location(
    '/compass/countries/${Uri.encodeComponent(_self.country)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$ActivitiesRoute on GoRouteData {
  static ActivitiesRoute _fromState(GoRouterState state) =>
      const ActivitiesRoute();

  @override
  String get location => GoRouteData.$location('/activities');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$DestinationListRoute on GoRouteData {
  static DestinationListRoute _fromState(GoRouterState state) =>
      const DestinationListRoute();

  @override
  String get location => GoRouteData.$location('/compass/destinations-list');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$ActivityListRoute on GoRouteData {
  static ActivityListRoute _fromState(GoRouterState state) =>
      const ActivityListRoute();

  @override
  String get location => GoRouteData.$location('/compass/activities-list');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Destinations)
const destinationsProvider = DestinationsProvider._();

final class DestinationsProvider
    extends $AsyncNotifierProvider<Destinations, List<Destination>> {
  const DestinationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'destinationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$destinationsHash();

  @$internal
  @override
  Destinations create() => Destinations();

  @$internal
  @override
  $AsyncNotifierProviderElement<Destinations, List<Destination>> $createElement(
    $ProviderPointer pointer,
  ) => $AsyncNotifierProviderElement(pointer);
}

String _$destinationsHash() => r'414be64d1e6132639e92e6b9414c71d3d65ee6b7';

abstract class _$Destinations extends $AsyncNotifier<List<Destination>> {
  FutureOr<List<Destination>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Destination>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Destination>>>,
              AsyncValue<List<Destination>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Continents)
const continentsProvider = ContinentsProvider._();

final class ContinentsProvider
    extends $AsyncNotifierProvider<Continents, List<String>> {
  const ContinentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'continentsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$continentsHash();

  @$internal
  @override
  Continents create() => Continents();

  @$internal
  @override
  $AsyncNotifierProviderElement<Continents, List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $AsyncNotifierProviderElement(pointer);
}

String _$continentsHash() => r'265fe8f8a4e22aedff098027034e52a90a906e67';

abstract class _$Continents extends $AsyncNotifier<List<String>> {
  FutureOr<List<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<String>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(activities)
const activitiesProvider = ActivitiesProvider._();

final class ActivitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Activity>>,
          FutureOr<List<Activity>>
        >
    with $FutureModifier<List<Activity>>, $FutureProvider<List<Activity>> {
  const ActivitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activitiesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activitiesHash();

  @$internal
  @override
  $FutureProviderElement<List<Activity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Activity>> create(Ref ref) {
    return activities(ref);
  }
}

String _$activitiesHash() => r'8e5bc45cb867ddfb6d1eb0123689f7cd02ec4dfb';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
