
import 'package:flutter/material.dart';

import 'app.dart';

class AppRouter {

  static const String UNKNOWN_SCREEN = 'unknown_screen';

  AppRouter();

  static AppNavigation? nav;

  static void push(BuildContext context, String path, {
    bool root = false,
    Map<String, dynamic> params = const <String, dynamic>{},
    int replace = 0,
  }) {
    AppRouter.nav = AppNavigation(path);
    AppRouter.nav!.params.addAll(params);

    if (root) {
      Navigator.of(context).pushNamedAndRemoveUntil(path, (_) => false, arguments: params); return;
    } else {
      if (replace > 0) {
        int actualReplace = 0;
        Navigator.of(context).pushNamedAndRemoveUntil(path, (_) => actualReplace++ >= replace, arguments: params); return;
      } else {
        Navigator.of(context).pushNamed(path, arguments: params);
      }
    }
  }

  static Widget pathContent(BuildContext context, String path, {Map<String, dynamic> params = const <String, dynamic>{}}) {

    if(!App.routes.containsKey(path)) {
      return ArgumentError.checkNotNull(App.routes[UNKNOWN_SCREEN])(context);
    }
    if (params != null) {
      AppRouter.nav = AppNavigation(path);
      AppRouter.nav!.params.addAll(params);
    }
    return ArgumentError.checkNotNull(App.routes[path])(context);
  }

  static void pushScreen(BuildContext context, Widget screen, {bool root = false, bool animate = true}) {
    if (root) {
      if (animate) {
        Navigator.of(context).pushAndRemoveUntil<Widget>(MaterialPageRoute(builder: (_) => screen), (route) => false); return;
      } else {
        Navigator.of(context).pushAndRemoveUntil<Widget>(PageRouteBuilder(pageBuilder: (_, __, ___) => screen), (route) => false); return;
      }
    }
    if (!root) {
      if (animate) {
        Navigator.of(context).push(MaterialPageRoute<Widget>(builder: (_) => screen)); return;
      } else {
        Navigator.of(context).push(PageRouteBuilder<Widget>(pageBuilder: (_, __, ___) => screen)); return;
      }
    }
  }

  static void pushRoute(BuildContext context, PageRoute route, {bool root = false}) {
    if (root) {
      Navigator.of(context).pushAndRemoveUntil<dynamic>(route, (_) => false); return;
    } else {
      Navigator.of(context).push<dynamic>(route); return;
    }
  }

  static void pop(BuildContext context, {int popCount = 0, bool root = false}) {

    if (Navigator.of(context).canPop()) {
      if (root) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (popCount > 0) {
        int actualPop = 0;
        Navigator.of(context).popUntil((route) => actualPop++ >= popCount);
      } else {
        Navigator.of(context).pop();
      }
      return;
    }
  }

  static bool canPop(BuildContext context) => Navigator.of(context).canPop();
}

class AppNavigation {

  final String path;
  final Map<String, dynamic> params = <String, dynamic>{};

  AppNavigation(this.path);
}