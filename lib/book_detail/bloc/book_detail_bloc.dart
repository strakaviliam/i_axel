import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iaxel/app/app_error.dart';
import 'package:iaxel/app/app_result.dart';
import '../bloc/book_detail_state.dart';
import '../model/book_model.dart';
import '../repository/book_detail_repository.dart';

class BookDetailBloc extends Cubit<BookDetailState> {

  final BookDetailRepository bookDetailRepository;

  BookDetailBloc({required this.bookDetailRepository}) : super(const BookDetailState.init());

  Future<void> loadBookDetail(String isbn13) async {
    emit(const BookDetailState.loading());
    try {
      final BookModel response = await bookDetailRepository.loadBook(isbn13);
      emit(BookDetailState.loaded(response));
    } on ErrorResult catch (ex) {
      emit(BookDetailState.error(AppError(ex.error, key: ex.key, errors: ex.errors)));
    }
  }

}
