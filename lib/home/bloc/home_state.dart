import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iaxel/app/app_error.dart';
import '../model/book_model.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.init() = Init;
  const factory HomeState.error(AppError error) = Error;
  const factory HomeState.loaded(List<BookModel> books, int total) = Loaded;
  const factory HomeState.loading() = Loading;
}
