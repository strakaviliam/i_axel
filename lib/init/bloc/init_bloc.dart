
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iaxel/app/app.dart';

import 'init_state.dart';

class InitBloc extends Cubit<InitState> {

  InitBloc() : super(const InitState.loading());

  Future<void> initApplication() async {
    emit(const InitState.loading());

    await App.cache.init();

    App.cache.setup(
      apiEndpoint: App.appConfig.endpoint,
    );

    await Future.delayed(const Duration(milliseconds: 500), () {});
    emit(const InitState.loaded());
  }
}
