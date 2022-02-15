import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app/app.dart';
import 'app/app_config.dart';
import 'app/app_package.dart';
import 'app/app_widget.dart';
import 'book_detail/book_detail_package.dart';
import 'home/home_package.dart';
import 'init/init_package.dart';
import 'main_widget.dart';
import 'unknown/unknown_package.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  App.instance.init(
      config: AppConfig(
        endpoint: 'https://api.itbook.store/1.0',
      ),
      packages: packages(),
      registerScreen: () {
        GetIt.I.registerFactory<AppWidget>(() => const MainWidget());
      }
  );

  App.instance.run();
}

List<AppPackage> packages() {
  return [
    UnknownPackage(),
    InitPackage(),
    HomePackage(),
    BookDetailPackage(),
  ];
}
