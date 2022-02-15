import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iaxel/app/api.dart';
import 'package:iaxel/app/app.dart';
import 'package:iaxel/app/app_bloc.dart';
import 'package:iaxel/app/app_config.dart';
import 'package:iaxel/app/app_widget.dart';
import 'package:iaxel/book_detail/bloc/book_detail_bloc.dart';
import 'package:iaxel/book_detail/repository/book_detail_repository.dart';
import 'package:iaxel/home/bloc/home_bloc.dart';
import 'package:iaxel/home/repository/home_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'main_widget_tests.dart';

class CommonTests {
  CommonTests();

  static void setupDependencies({
    BookDetailRepository? bookDetailRepository,
    HomeRepository? homeRepository,
  }) {
    GetIt.I.allowReassignment = true;

    App.instance.init(
      config: AppConfig(
        endpoint: '',
      ),
      packages: [],
      registerScreen: () {
        GetIt.I.registerFactory<AppWidget>(() => MainWidgetTests(homeScreen: Container()));
      },
      registerRepo: () {
        GetIt.I.registerFactory<HomeRepository>(() => homeRepository ?? MockHomeRepository());
        GetIt.I.registerFactory<BookDetailRepository>(() => bookDetailRepository ?? MockBookDetailRepository());
      },
      registerBloc: () {
        GetIt.I.registerFactory<AppBloc>(() => AppBloc());
        GetIt.I.registerFactory<BookDetailBloc>(() => BookDetailBloc(
          bookDetailRepository: GetIt.I.get<BookDetailRepository>(),
        ));
        GetIt.I.registerFactory<HomeBloc>(() => HomeBloc(
          homeRepository: GetIt.I.get<HomeRepository>(),
        ));
      },
    );
  }

}

class MockApi extends Mock implements Api {}
class MockHomeRepository extends Mock implements HomeRepository {}
class MockBookDetailRepository extends Mock implements BookDetailRepository {}
