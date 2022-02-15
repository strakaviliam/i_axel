import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iaxel/app/app.dart';
import 'package:iaxel/app/app_progress.dart';
import 'package:iaxel/app/app_router.dart';
import 'package:iaxel/common/constant.dart';
import 'package:iaxel/common/widget/screen.dart';

import '../bloc/init_bloc.dart';
import '../bloc/init_state.dart';

class InitScreen extends Screen {
  static const String name = ScreenPath.INIT_SCREEN;

  InitScreen({Key? key}) : super(name, key: key);

  @override
  State<StatefulWidget> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<InitBloc>(context).initApplication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<InitBloc, InitState>(
        listener: (context, state) {
          context.setLocale(Locale(App.cache.language));
          state.maybeWhen(
            loaded: () async {
              context.setLocale(Locale(App.cache.language));
              AppRouter.pushScreen(context, AppRouter.pathContent(context, ScreenPath.HOME_SCREEN), root: true, animate: false);
            },
            orElse: () {},
          );
        },
        child: const Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: AppProgress(),
          ),
        ),
      ),
    );
  }
}
