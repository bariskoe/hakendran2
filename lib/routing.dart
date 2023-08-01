import 'package:baristodolistapp/pages/login_page.dart';
import 'package:baristodolistapp/pages/main_page.dart';
import 'package:flutter/material.dart';

class Routing {
  static String get loginPage => '/loginPage';

  static String get mainPage => '/mainPage';

  static Map<String, Widget Function(BuildContext)> routes = {
    loginPage: (context) => const LoginPage(),
    mainPage: (context) => const MainPage(),
  };
}
