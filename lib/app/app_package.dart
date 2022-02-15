import 'package:flutter/material.dart';

abstract class AppPackage {
  void registerRepo(){}
  void registerBloc(){}
  void registerScreen() {}
  void registerRoute(Map<String, WidgetBuilder> routes) {}
  Map<String, Map<String, dynamic>> localizedValues() => {};
}
