import 'package:baristodolistapp/bloc/authentication/authentication_bloc.dart';
import 'package:baristodolistapp/domain/repositories/authentication_repository.dart';
import 'package:baristodolistapp/infrastructure/datasources/api_datasource.dart';
import 'package:baristodolistapp/infrastructure/datasources/api_datasource_impl.dart';
import 'package:baristodolistapp/infrastructure/repositories/authentication_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import 'domain/repositories/selected_todolist_repository.dart';
import 'infrastructure/repositories/selected_todolist_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/allTodoLists/all_todolists_bloc.dart';
import 'bloc/selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';
import 'domain/repositories/all_todolists_repository.dart';
import 'domain/usecases/all_todolists_usecases.dart';
import 'domain/usecases/selected_todolist_usecases.dart';
import 'infrastructure/datasources/local_sqlite_datasource.dart';
import 'infrastructure/datasources/local_sqlite_datasource_impl.dart';
import 'infrastructure/repositories/all_todo_lists_repository_impl.dart';

final getIt = GetIt.I;

Future<void> setupDependencyInjectionWithGetIt() async {
//! application layer
  getIt.registerLazySingleton<AuthenticationBloc>(() => AuthenticationBloc(
        authenticationRepository: getIt(),
      ));

  getIt.registerLazySingleton<AllTodolistsBloc>(() => AllTodolistsBloc(
        allTodoListsUsecases: getIt(),
        selectedTodolistBloc: getIt(),
      ));
  getIt.registerLazySingleton<SelectedTodolistBloc>(() => SelectedTodolistBloc(
        selectedTodolistUsecases: getIt(),
      ));

//! Usecases
  getIt.registerLazySingleton<AllTodoListsUsecases>(() => AllTodoListsUsecases(
        allTodoListsRepository: getIt(),
      ));
  getIt.registerLazySingleton<SelectedTodolistUsecases>(
      () => SelectedTodolistUsecases(
            selectedTodolistRepository: getIt(),
          ));

//! repos
  getIt.registerLazySingleton<AllTodoListsRepository>(
      () => AllTodoListsRepositoryImpl(
            localSqliteDataSource: getIt(),
            apiDatasource: getIt(),
          ));
  getIt.registerLazySingleton<SelectedTodolistRepository>(
      () => SelectedTodoListRepositoryImpl(localSqliteDataSource: getIt()));

  getIt.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(firebaseAuth: getIt()));
//! Datasources
  getIt.registerLazySingleton<LocalSqliteDataSource>(
      () => LocalSqliteDataSourceImpl());
  getIt.registerLazySingleton<ApiDatasource>(
    () => ApiDatasourceImpl(),
  );

  getIt.registerSingleton(await SharedPreferences.getInstance());

  //! Authentication
  final firebaseAuth = FirebaseAuth.instance;
  getIt.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  Stream<User?> firebaseAuthStateStream = firebaseAuth.authStateChanges();
  getIt.registerLazySingleton<Stream<User?>>(() => firebaseAuthStateStream);
}
