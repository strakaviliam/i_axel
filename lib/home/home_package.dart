import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iaxel/app/app_package.dart';

import 'bloc/home_bloc.dart';
import 'repository/home_repository.dart';
import 'repository/home_repository_api.dart';
import 'ui/home_screen.dart';

class HomePackage extends AppPackage {

  @override
  void registerRepo() {
    GetIt.I.registerFactory<HomeRepository>(() => HomeRepositoryApi());
  }

  @override
  void registerBloc() {
    GetIt.I.registerFactory<HomeBloc>(() => HomeBloc(
      homeRepository: GetIt.I.get<HomeRepository>(),
    ));
  }

  @override
  void registerScreen() {
    GetIt.I.registerFactory<HomeScreen>(() => HomeScreen());
  }

  @override
  void registerRoute(Map<String, WidgetBuilder> routes) {

    routes[HomeScreen.name] = (_) => BlocProvider<HomeBloc>(
      create: (_) => GetIt.I.get<HomeBloc>(),
      child: GetIt.I.get<HomeScreen>(),
    );
  }

  @override
  Map<String, Map<String, String>> localizedValues() => {
    'en': {
      'home__search_hint': 'Search...',
      'home__result_empty': 'No results',
      'home__result_loading': 'Loading...',
      'home__result_pull_up': 'Pull up Load more',
      'home__result_release': 'Release to load more',
    },
  };
}
