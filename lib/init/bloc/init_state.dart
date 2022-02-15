import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iaxel/app/app_error.dart';

part 'init_state.freezed.dart';

@freezed
abstract class InitState with _$InitState {
  const factory InitState.error(AppError error) = Error;
  const factory InitState.loaded() = Loaded;
  const factory InitState.loading() = Loading;
}
