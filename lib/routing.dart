import 'package:get/get_navigation/src/routes/get_route.dart';

import 'pages/data_preparation_page.dart';
import 'pages/initial_routing_page.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';

class RoutingService {
  static String get initialRoutingPage => '/';
  static String get loginPage => '/loginPage';
  static String get mainPage => '/mainPage';
  static String get dataPreparationPage => '/dataPreparationPage';

  static List<GetPage> get getXRoutes => [
        GetPage(
            name: initialRoutingPage, page: () => const InitialRoutingPage()),
        GetPage(name: loginPage, page: () => const LoginPage()),
        GetPage(
          name: dataPreparationPage,
          page: () => const DatapreparationPage(),
        ),
        GetPage(
          name: mainPage,
          page: () => const MainPage(),
        ),
      ];
}
