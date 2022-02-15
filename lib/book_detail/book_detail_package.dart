import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iaxel/app/app_package.dart';

import 'bloc/book_detail_bloc.dart';
import 'repository/book_detail_repository.dart';
import 'repository/book_detail_repository_api.dart';
import 'ui/book_detail_screen.dart';

class BookDetailPackage extends AppPackage {

  @override
  void registerRepo() {
    GetIt.I.registerFactory<BookDetailRepository>(() => BookDetailRepositoryApi());
  }

  @override
  void registerBloc() {
    GetIt.I.registerFactory<BookDetailBloc>(() => BookDetailBloc(
      bookDetailRepository: GetIt.I.get<BookDetailRepository>(),
    ));
  }

  @override
  void registerScreen() {
    GetIt.I.registerFactory<BookDetailScreen>(() => BookDetailScreen());
  }

  @override
  void registerRoute(Map<String, WidgetBuilder> routes) {

    routes[BookDetailScreen.name] = (_) => BlocProvider<BookDetailBloc>(
      create: (_) => GetIt.I.get<BookDetailBloc>(),
      child: GetIt.I.get<BookDetailScreen>(),
    );
  }

  @override
  Map<String, Map<String, String>> localizedValues() => {
    'en': {
      'book_detail__preview_title': 'Preview',
    },
  };
}
