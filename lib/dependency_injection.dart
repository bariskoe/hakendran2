import 'dart:async';

import 'package:baristodolistapp/bloc/photo/photo_bloc.dart';
import 'package:baristodolistapp/domain/repositories/photo_repository.dart';
import 'package:baristodolistapp/infrastructure/repositories/photo_repository_impl.dart';
import 'package:baristodolistapp/services/firebase_storage_service.dart';
import 'package:baristodolistapp/services/folder_creator.dart';
import 'package:baristodolistapp/services/image_picker_service.dart';
import 'package:baristodolistapp/services/path_builder.dart';
import 'package:baristodolistapp/services/string_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/DataPreparation/bloc/data_preparation_bloc.dart';
import 'bloc/allTodoLists/all_todolists_bloc.dart';
import 'bloc/authentication/authentication_bloc.dart';
import 'bloc/selectedTodolist_bloc/bloc/selected_todolist_bloc.dart';
import 'domain/repositories/all_todolists_repository.dart';
import 'domain/repositories/api_repository.dart';
import 'domain/repositories/authentication_repository.dart';
import 'domain/repositories/connectivity_repository.dart';
import 'domain/repositories/data_preparation_repository.dart';
import 'domain/repositories/selected_todolist_repository.dart';
import 'domain/usecases/all_todolists_usecases.dart';
import 'domain/usecases/api_usecases.dart';
import 'domain/usecases/data_preparation_usecases.dart';
import 'domain/usecases/photo_usecases.dart';
import 'domain/usecases/selected_todolist_usecases.dart';
import 'infrastructure/datasources/api_datasource.dart';
import 'infrastructure/datasources/api_datasource_impl_new.dart';
import 'infrastructure/datasources/local_sqlite_datasource.dart';
import 'infrastructure/datasources/local_sqlite_datasource_impl.dart';
import 'infrastructure/repositories/all_todo_lists_repository_impl.dart';
import 'infrastructure/repositories/api_repository_impl.dart';
import 'infrastructure/repositories/authentication_repository_impl.dart';
import 'infrastructure/repositories/connectivity_repository_impl.dart';
import 'infrastructure/repositories/data_preparation_repository_impl.dart';
import 'infrastructure/repositories/selected_todolist_repository_impl.dart';
import 'services/connectivity_service.dart';

final getIt = GetIt.I;

Future<void> setupDependencyInjectionWithGetIt() async {
//! application layer
  getIt.registerLazySingleton<AuthenticationBloc>(() => AuthenticationBloc(
        authenticationRepository: getIt(),
      ));
  getIt.registerLazySingleton<DataPreparationBloc>(() => DataPreparationBloc(
      dataPreparationUsecases: getIt(),
      allTodoListsUsecases: getIt(),
      selectedTodoListBloc: getIt()));

  getIt.registerLazySingleton<AllTodolistsBloc>(() => AllTodolistsBloc(
        allTodoListsUsecases: getIt(),
        connectivityRepository: getIt(),
        selectedTodolistBloc: getIt(),
        apiUsecases: getIt(),
        selectedTodolistUsecases: getIt(),
      ));
  getIt.registerLazySingleton<SelectedTodolistBloc>(() => SelectedTodolistBloc(
        selectedTodolistUsecases: getIt(),
      ));
  getIt.registerLazySingleton(() => PhotoBloc(photoUsecases: getIt()));

//! Usecases
  getIt.registerLazySingleton<DataPreparationUsecases>(
      () => DataPreparationUsecases(dataPreparationRepository: getIt()));
  getIt.registerLazySingleton<AllTodoListsUsecases>(() => AllTodoListsUsecases(
        allTodoListsRepository: getIt(),
      ));
  getIt.registerLazySingleton<SelectedTodolistUsecases>(
      () => SelectedTodolistUsecases(
            selectedTodolistRepository: getIt(),
          ));
  getIt.registerLazySingleton<ApiUsecases>(() => ApiUsecases(
        apiRepository: getIt(),
      ));
  getIt.registerLazySingleton<PhotoUsecases>(() => PhotoUsecases(
        photoRepository: getIt(),
        apiRepository: getIt(),
        dataPreparationRepository: getIt(),
      ));

//! repos
  getIt.registerLazySingleton<DataPreparationRepository>(
      () => DataPreparationRepositoryImpl(
            apiDatasource: getIt(),
            localSqliteDataSource: getIt(),
          ));
  getIt.registerLazySingleton<AllTodoListsRepository>(
      () => AllTodoListsRepositoryImpl(
            localSqliteDataSource: getIt(),
            apiDatasource: getIt(),
          ));
  getIt.registerLazySingleton<SelectedTodolistRepository>(
      () => SelectedTodoListRepositoryImpl(localSqliteDataSource: getIt()));

  getIt.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(firebaseAuth: getIt()));

  getIt.registerLazySingleton<ConnectivityRepository>(
      () => ConnectivityRepositoryImpl(
            connectivity: getIt(),
          ));
  getIt.registerLazySingleton<ApiRepository>(() => ApiRepositoryImpl(
        apiDatasource: getIt(),
        firebaseStorageService: getIt(),
      ));
  getIt.registerLazySingleton<PhotoRepository>(
      () => PhotoRepositoryImpl(pathBuilder: getIt()));
//! Datasources
  getIt.registerLazySingleton<LocalSqliteDataSource>(
      () => LocalSqliteDataSourceImpl());
  getIt.registerLazySingleton<ApiDatasource>(
    () => ApiDataSourceImplNew(
      firebaseStorageService: getIt(),
      localSqliteDataSource: getIt(),
    ),
  );

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  getIt.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
  getIt.registerSingleton<FirebaseStorageService>(FirebaseStorageService.forDi(
      firebaseStorage: firebaseStorage, sharedPreferences: getIt()));

  //! Authentication
  final firebaseAuth = FirebaseAuth.instance;
  getIt.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  Stream<User?> firebaseAuthStateStream = firebaseAuth.authStateChanges();
  getIt.registerLazySingleton<Stream<User?>>(() => firebaseAuthStateStream);

  //! Connectivity
  final connectivity = Connectivity();
  getIt.registerSingleton<Connectivity>(connectivity);
  getIt.registerSingleton<ConnectivityService>(
      ConnectivityService.forDi(getIt()));

  //! ImagePickerService
  final ImagePicker imagePicker = ImagePicker();
  getIt.registerSingleton<ImagePicker>(imagePicker);
  getIt
      .registerSingleton<ImagePickerService>(ImagePickerService.forDi(getIt()));

  //! Strings
  getIt.registerSingleton<StringService>(StringService.forDi(getIt()));
  getIt.registerSingleton<PathBuilder>(
      PathBuilder.forDi(sharedPreferences: getIt()));

  //! Folders
  getIt.registerSingleton<FolderCreator>(FolderCreator.forDi(getIt()));
}
