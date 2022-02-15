import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iaxel/app/app_package.dart';

import 'bloc/init_bloc.dart';
import 'ui/init_screen.dart';

class InitPackage extends AppPackage {

  @override
  void registerBloc() {
    GetIt.I.registerFactory<InitBloc>(() => InitBloc());
  }

  @override
  void registerScreen() {
    GetIt.I.registerFactory<InitScreen>(() => InitScreen());
  }

  @override
  void registerRoute(Map<String, WidgetBuilder> routes) {

    routes[InitScreen.name] = (_) => BlocProvider<InitBloc>(
      create: (_) => GetIt.I.get<InitBloc>(),
      child: GetIt.I.get<InitScreen>(),
    );
  }

  @override
  Map<String, Map<String, String>> localizedValues() => {
    'en': {
      'ok': 'OK',
      'sorry': 'Sorry',
      'try_again': 'Try again',
      'yes': 'Yes',
      'no': 'No',
      'cancel': 'Cancel',
    },
  };
}
