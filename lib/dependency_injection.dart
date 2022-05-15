import 'package:baristodolistapp/bloc/allTodoLists/all_todolists_bloc.dart';
import 'package:baristodolistapp/domain/repositories/allTodolists_repository.dart';
import 'package:baristodolistapp/infrastructure/datasources/local_sqlite_datasource.dart';
import 'package:baristodolistapp/infrastructure/datasources/local_sqlite_datasource_impl.dart';
import 'package:baristodolistapp/infrastructure/repositories/all_todo_lists_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';
import 'domain/usecases/allTodoLists_usecases.dart';

final getIt = GetIt.I;

Future<void> setupDependencyInjectionWithGetIt() async {
//! application layer
  getIt.registerFactory(() => AllTodolistsBloc(
      allTodoListsUsecases: getIt(), selectedTodolistBloc: getIt()));
  getIt.registerFactory(() => SelectedTodolistBloc());

//! Usecases
  getIt.registerLazySingleton(
      () => AllTodoListsUsecases(allTodoListsRepository: getIt()));

  //! repos

  getIt.registerLazySingleton<AllTodoListsRepository>(
      () => AllTodoListsRepositoryImpl(localSqliteDataSource: getIt()));

  getIt.registerLazySingleton<LocalSqliteDataSource>(
      () => LocalSqliteDataSourceImpl());

  //getIt.registerLazySingleton(() => TodosBlocBloc());
  getIt.registerSingleton(await SharedPreferences.getInstance());
}
