import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_state.dart';
import 'tools/tools.dart';


class AppBloc extends Cubit<AppState> {

  AppBloc() : super(const AppState.initial());

  Future<void> updateApp() async {
    emit(AppState.update(Tools.randomString()));
  }
}
