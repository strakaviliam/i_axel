import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iaxel/app/app.dart';
import 'package:iaxel/app/app_router.dart';
import 'package:iaxel/common/widget/screen.dart';

class UnknownScreen extends Screen {
  static const String name = AppRouter.UNKNOWN_SCREEN;

  UnknownScreen({Key? key}) : super(name, key: key);

  @override
  State<StatefulWidget> createState() => _UnknownScreenState();
}

class _UnknownScreenState extends State<UnknownScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('unknown__title'.tr(), style: App.appTheme.textHeader),
              const SizedBox(height: 32),
              Text('unknown__message'.tr(), style: App.appTheme.textTitle),
            ],
          ),
        ),
      ),
    );
  }
}
