import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iaxel/app/app.dart';
import 'package:iaxel/app/app_bloc.dart';
import 'package:iaxel/app/app_widget.dart';
import 'package:iaxel/book_detail/bloc/book_detail_bloc.dart';
import 'package:iaxel/home/bloc/home_bloc.dart';

class MainWidgetTests extends AppWidget {

  final Widget homeScreen;

  const MainWidgetTests({Key? key, required this.homeScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: (BuildContext context) => GetIt.I.get<AppBloc>()),
        BlocProvider<BookDetailBloc>(create: (BuildContext context) => GetIt.I.get<BookDetailBloc>()),
        BlocProvider<HomeBloc>(create: (BuildContext context) => GetIt.I.get<HomeBloc>()),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: App.appTheme.themeData,
          routes: App.routes,
          home: homeScreen,
        );
      }),
    );
  }
}
