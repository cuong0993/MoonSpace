import 'dart:async';

import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:moonspace/controller/app_scroll_behavior.dart';
import 'package:moonspace/feedback/feedback_form.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:moonspace/provider/pref.dart';
import 'package:moonspace/theme.dart';
import 'package:moonspace/provider/global_theme.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();
const String spacemoonRestorationScopeId = 'SpacemoonRestorationScopeId';
const String appRestorationScopeId = 'AppRestorationScopeId';

class SpaceMoonHome extends ConsumerWidget {
  const SpaceMoonHome({
    super.key,
    required this.electricKey,
    required this.router,
    required this.title,
    this.localizationsDelegates,
    this.supportedLocales,
    required this.debugUi,
    required this.errorChild,
  });

  final String title;

  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final List<Locale>? supportedLocales;

  final GoRouter? router;

  final Key electricKey;
  final bool debugUi;

  final Widget errorChild;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return AppThemeWidget(
    //   dark: false,
    //   designSize: const Size(430, 932),
    //   maxSize: const Size(1366, 1024),
    //   size: MediaQuery.of(context).size,
    //   child: Builder(builder: (context) {
    //     return MaterialApp(
    //       title: title,
    //       theme: AppTheme.currentAppTheme.theme,
    //       debugShowCheckedModeBanner: kDebugMode,
    //     );
    //   }),
    // );

    final globalAppTheme = ref.watch(globalThemeProvider);
    final brightness = globalAppTheme.theme.brightness;
    final appColor = globalAppTheme.color;

    return RootRestorationScope(
      restorationId: spacemoonRestorationScopeId,
      child: LayoutBuilder(
        builder: (context, constraints) {
          AppTheme.currentAppTheme = AppTheme(
            dark: brightness == Brightness.dark,
            size: constraints.biggest,
            maxSize: const Size(1366, 1024),
            designSize: const Size(430, 932),
            appColor: appColor,
          );

          dino('SpaceMoon Rebuild ${constraints.biggest} \n');

          return MaterialApp.router(
            routerConfig: router,
            title: title,
            scaffoldMessengerKey: scaffoldMessengerKey,
            localizationsDelegates: localizationsDelegates,
            theme: AppTheme.currentAppTheme.theme,
            themeAnimationCurve: Curves.ease,
            debugShowCheckedModeBanner: debugUi,
            restorationScopeId: appRestorationScopeId,
            scrollBehavior: AppScrollBehavior(),

            // showSemanticsDebugger: true,
            // showPerformanceOverlay: true,
            supportedLocales: [Locale('en', 'US'), ...?supportedLocales],

            builder: (context, child) {
              initializeDateFormatting();

              // if (kIsWeb) {
              //   return DevicePreview(
              //     builder: (context) {
              //       return ElectricWrap(
              //         theme: globalAppTheme.theme,
              //         brightness: brightness,
              //         child: child,
              //       );
              //     },
              //   );
              // }

              return Directionality(
                textDirection: TextDirection.ltr,
                child: Scaffold(
                  key: ValueKey(globalAppTheme.theme),
                  resizeToAvoidBottomInset: false,
                  body: Overlay(
                    initialEntries: [
                      OverlayEntry(
                        builder: (context) {
                          return CupertinoTheme(
                            key: electricKey,
                            data: CupertinoThemeData(
                              brightness: brightness,
                              primaryColor: AppTheme.seedColor,
                            ),
                            child: child ?? errorChild,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void electrify({
  required String title,
  required void Function(WidgetsBinding widgetsBinding) before,
  required void Function() after,
  required Key electricKey,
  required GoRouter? router,
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  final List<Locale>? supportedLocales,
  required AsyncCallback init,
  required Widget errorChild,
  required void Function(FlutterErrorDetails details) recordFlutterFatalError,
  required void Function(Object error, StackTrace stack) recordError,
  required void Function(ProviderContainer providerContainer) providerInit,
  required bool debugUi,
}) async {
  runZonedGuarded(
    () async {
      // debugPaintSizeEnabled = true;
      // debugPaintLayerBordersEnabled = true;
      // debugRepaintRainbowEnabled = true;
      // debugPaintBaselinesEnabled = true;
      // debugPaintPointersEnabled = true;
      // debugPrintMarkNeedsLayoutStacks = true;
      // debugPrintMarkNeedsPaintStacks = true;

      //
      BindingBase.debugZoneErrorsAreFatal = true;
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

      before(widgetsBinding);

      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);

      // ErrorWidget.builder = (FlutterErrorDetails details) {
      //   if (kDebugMode) {
      //     return ErrorPage(error: details);
      //   }
      //   return const SizedBox();
      // };

      // This captures errors reported by the Flutter framework.
      FlutterError.onError = (FlutterErrorDetails details) async {
        final dynamic exception = details.exception;
        final StackTrace? stackTrace = details.stack;

        if (kDebugMode) {
          FlutterError.presentError(details);
          debugPrint(exception.toString());
          debugPrintStack(stackTrace: stackTrace);
        } else {
          if (Device.isMobile) {
            recordFlutterFatalError(details);
          }

          Zone.current.handleUncaughtError(exception, stackTrace!);
        }
      };

      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        if (kDebugMode) {
          debugPrint(error.toString());
          debugPrintStack(stackTrace: stack);
        } else {
          if (Device.isMobile) {
            recordError(error, stack);
          }
        }
        return true;
      };

      //-----

      // ignore: missing_provider_scope
      // runApp(const SplashPage(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Image.asset(Asset.spaceMoon),
      //       Text('Built by shark.run', style: context.tm),
      //     ],
      //   ),
      // ));

      final container = ProviderContainer();

      container.listen(prefProvider, (prev, next) {});

      await init();

      providerInit(container);

      await Future.delayed(const Duration(milliseconds: 100));

      runApp(
        UncontrolledProviderScope(
          container: container,
          child: BetterFeedback(
            feedbackBuilder: (context, onSubmit, scrollController) {
              return FeedbackForm(
                onSubmit: onSubmit,
                scrollController: scrollController,
              );
            },
            theme: FeedbackThemeData(),
            localizationsDelegates: [GlobalFeedbackLocalizationsDelegate()],
            child: SpaceMoonHome(
              title: title,
              electricKey: electricKey,
              router: router,
              localizationsDelegates: localizationsDelegates,
              supportedLocales: supportedLocales,
              errorChild: errorChild,
              debugUi: debugUi,
            ),
          ),
        ),
      );

      after();
    },
    (error, stack) {
      if (kDebugMode) {
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stack);
      } else {
        if (Device.isMobile) {
          recordError(error, stack);
        }
      }
    },
  );
}
