import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iaxel/app/app_error.dart';
import 'package:iaxel/app/app_result.dart';
import '../model/home_response.dart';

import '../repository/home_repository.dart';
import 'home_state.dart';

class HomeBloc extends Cubit<HomeState> {

  final HomeRepository homeRepository;
  String _waitingKey = '';
  HomeBloc({required this.homeRepository}) : super(const HomeState.init());

  Future<void> newBooks() async {
    emit(const HomeState.loading());
    try {
      final HomeResponse response = await homeRepository.newBooks();
      emit(HomeState.loaded(response.books, response.total));
    } on ErrorResult catch (ex) {
      emit(HomeState.error(AppError(ex.error, key: ex.key, errors: ex.errors)));
    }
  }

  Future<void> searchBooks({int page = 1, String query = ''}) async {
    emit(const HomeState.loading());
    _waitingKey = query;
    try {
      final HomeResponse response = await homeRepository.searchBooks(page, query, _waitingKey);
      if (response.key != _waitingKey) {
        return;
      }
      emit(HomeState.loaded(response.books, response.total));
    } on ErrorResult catch (ex) {
      emit(HomeState.error(AppError(ex.error, key: ex.key, errors: ex.errors)));
    }
  }
}
