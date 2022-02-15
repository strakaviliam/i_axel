import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'app_bloc.dart';
import 'app_cache.dart';
import 'app_config.dart';
import 'app_package.dart';
import 'app_theme.dart';
import 'app_widget.dart';

class App {

  factory App() => _instance;
  static App _instance = App._();
  factory App.newInstance() => _instance = App._();
  App._();

  static App get I => App();
  static App get instance => App();

  late AppConfig _appConfig;
  static AppConfig get appConfig => I._appConfig;

  late AppTheme _appTheme;
  static AppTheme get appTheme => I._appTheme;

  final Map<String, WidgetBuilder> _routes = {};
  static Map<String, WidgetBuilder> get routes => I._routes;

  final AppCache _cache = AppCache();
  static AppCache get cache => I._cache;

  Map<String, Map<String, dynamic>> _localizedValues = {};

  Future<void> init({
    required AppConfig config,
    required List<AppPackage> packages,
    AppTheme? appTheme,
    Function()? registerScreen,
    Function()? registerRepo,
    Function()? registerBloc,
  }) async {
    _localizedValues = {};
    _appConfig = config;
    _appTheme = appTheme ?? AppTheme();

    //register base

    GetIt.I.registerSingleton<Logger>(Logger(
      level: Level.debug,
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 0,
        lineLength: 200,
      ),
      // filter: ReleaseLogFilter(),
    ));

    GetIt.I.registerFactory<AppBloc>(() => AppBloc());

    //register packages
    for (final package in packages) {
      package.registerRepo();
      package.registerBloc();
      package.registerScreen();
      package.registerRoute(_routes);
      package.localizedValues().forEach((lang, values) {
        final Map<String, dynamic> local = _localizedValues[lang] ?? <String, dynamic>{};
        values.forEach((key, dynamic value) {
          local[key] = value;
        });
        _localizedValues[lang] = local;
      });
    }
    registerRepo?.call();
    registerBloc?.call();
    registerScreen?.call();

    //check if app widget is registered
    assert(GetIt.I.isRegistered<AppWidget>());
  }

  void run() {

    FlutterError.onError = (details) async {
      if (!kReleaseMode) {
        FlutterError.dumpErrorToConsole(details);
      } else if (details.stack != null){
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      }
    };

    final AppWidget appWidget = GetIt.I.get<AppWidget>();

    runZonedGuarded<Future<void>>(() async {
      runApp(EasyLocalization(
        key: UniqueKey(),
        supportedLocales: App.cache.languages.map((lang) => Locale(lang)).toList(),
        path: 'local',
        assetLoader: AppqaAssetLoader(_localizedValues),
        fallbackLocale: const Locale('en'),
        child: appWidget,
      ));
    }, (Object exception, StackTrace stackTrace) async {
      if (exception is Exception) {
        GetIt.I.get<Logger>().wtf('Zone level exception', exception, stackTrace);
      } else if (exception is Error) {
        GetIt.I.get<Logger>().wtf('Zone level error', exception, stackTrace);
      }
      GetIt.I.get<Logger>().e('Zone level error: $stackTrace', exception, stackTrace);
    });
  }
}

class ReleaseLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

class AppqaAssetLoader extends AssetLoader {

  Map<String, Map<String, dynamic>> localizedValues;
  AppqaAssetLoader(this.localizedValues);

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    return localizedValues[locale.languageCode] ?? localizedValues['en'];
  }
}
