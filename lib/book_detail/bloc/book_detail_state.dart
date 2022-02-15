import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iaxel/app/app_error.dart';
import '../model/book_model.dart';

part 'book_detail_state.freezed.dart';

@freezed
abstract class BookDetailState with _$BookDetailState {
  const factory BookDetailState.init() = Init;
  const factory BookDetailState.error(AppError error) = Error;
  const factory BookDetailState.loaded(BookModel book) = Loaded;
  const factory BookDetailState.loading() = Loading;
}
