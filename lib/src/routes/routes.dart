import 'package:app_reports/src/screens/screens.dart';
import 'package:flutter/material.dart';

final _routes = <String, WidgetBuilder> {
  '/'     : (__) => const SplashScreen(),
  'main'  :  (__) => const MainScreen(),
  'edit'  :  (__) => const AddReportScreen(),
};

Map<String, WidgetBuilder> getRoutes () {
  return _routes;
}
