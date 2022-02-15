import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'app/app.dart';
import 'app/app_bloc.dart';
import 'app/app_router.dart';
import 'app/app_state.dart';
import 'app/app_widget.dart';

class MainWidget extends AppWidget {

  const MainWidget({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: (BuildContext context) => GetIt.I.get<AppBloc>()),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: App.appTheme.themeData,
            initialRoute: App.appConfig.initScreen,
            routes: App.routes,
            onUnknownRoute: (settings) => MaterialPageRoute<void>(
              builder: (context) => App.routes[AppRouter.UNKNOWN_SCREEN]!(context),
            ),
          );
        },
      ),
    );
  }

}
