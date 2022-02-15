import 'package:freezed_annotation/freezed_annotation.dart';
part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState.initial() = Initial;
  const factory AppState.update(String key) = Update;
}
