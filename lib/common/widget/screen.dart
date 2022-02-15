import 'package:flutter/material.dart';
import 'package:iaxel/app/app_router.dart';

abstract class Screen extends StatefulWidget {

  final AppNavigation? nav;
  final Map<String, dynamic> params;

  Screen(String name, {Key? key}) :
        nav = (AppRouter.nav?.path == name) ? AppRouter.nav : null,
        params = initParams(name),
        super(key: key);

  static Map<String, dynamic> initParams(String name) {
    Map<String, dynamic> params = <String, dynamic>{};
    if (AppRouter.nav?.path == name) {
      params = AppRouter.nav!.params;
      AppRouter.nav = null;
    }
    return params;
  }
}
