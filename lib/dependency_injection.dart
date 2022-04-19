import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjectionWithGetIt() async {
  //getIt.registerLazySingleton(() => TodosBlocBloc());
  getIt.registerSingleton(await SharedPreferences.getInstance());
}
