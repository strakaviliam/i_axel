import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iaxel/app/app_package.dart';

import 'ui/unknown_screen.dart';

class UnknownPackage extends AppPackage {

  @override
  void registerScreen() {
    GetIt.I.registerFactory<UnknownScreen>(() => UnknownScreen());
  }

  @override
  void registerRoute(Map<String, WidgetBuilder> routes) {
    routes[UnknownScreen.name] = (_) => GetIt.I.get<UnknownScreen>();
  }

  @override
  Map<String, Map<String, String>> localizedValues() => {
    'en': {
      'unknown__title': 'Sorry',
      'unknown__message': 'We have problem find this screen.',
    },
  };
}
