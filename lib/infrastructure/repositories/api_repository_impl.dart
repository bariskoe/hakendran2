import '../../domain/parameters/upload_to_firebase_storage_parameters.dart';
import '../../services/firebase_storage_service.dart';
import 'package:dartz/dartz.dart';

import '../../domain/failures/failures.dart';
import '../../domain/parameters/delete_file_from_firebase_storage_params.dart';
import '../../domain/parameters/todo_parameters.dart';
import '../../domain/parameters/todolist_entity_parameters.dart';
import '../../domain/repositories/api_repository.dart';
import '../../models/api_action_model.dart';
import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';
import '../datasources/api_datasource.dart';

class ApiRepositoryImpl implements ApiRepository {
  final ApiDatasource apiDatasource;
  final FirebaseStorageService firebaseStorageService;

  ApiRepositoryImpl({
    required this.apiDatasource,
    required this.firebaseStorageService,
  });

  @override
  Future<Either<Failure, bool>> addTodoToSpecificList(
      {required TodoModel todoModel}) async {
    try {
      final uploadSuccessful =
          await apiDatasource.addTodoToSpecificList(todoModel: todoModel);
      if (uploadSuccessful) {
        return const Right(true);
      } else {
        return Left(ApiFailure());
      }
    } catch (e) {
      return Left(ApiFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> createTodoList({
    required TodoListEntityParameters todoListEntityParameters,
  }) async {
    try {
      final uploadSuccessful = await apiDatasource.createTodoList(
        todoListModel: TodoListModel.fromTodoListEntityParameters(
            todoListEntityParameters),
      );
      if (uploadSuccessful) {
        return const Right(true);
      } else {
        return Left(ApiFailure());
      }
    } catch (e) {
      return Left(ApiFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> performApiAction(
      {required ApiActionModel apiActionModel}) async {
    try {
      final actionSuccessful =
          await apiDatasource.performApiAction(apiActionModel: apiActionModel);
      if (actionSuccessful) {
        return const Right(true);
      } else {
        return Left(ApiFailure());
      }
    } catch (e) {
      return Left(ApiFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadToFirebaseStorage({
    required UploadToFirebaseStorageParameters
        uploadToFirebaseStorageParameters,
  }) async {
    try {
      final downloadUrl =
          await firebaseStorageService.uploadFileToFirebaseStorage(
              uploadToFirebaseStorageParameters:
                  uploadToFirebaseStorageParameters);
      if (downloadUrl != null) {
        return Right(downloadUrl);
      } else {
        return Left(FirebaseFailure(message: 'Failed to upload file'));
      }
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, bool>> deleteFileFromFirebaseStorage(
  //     {required DeleteFileFromFirebaseStorageParams
  //         deleteFileFromFirebaseStorageParams}) async {
  //   try {
  //     bool success = await firebaseStorageService.deleteFileFromFirebaseStorage(
  //         deleteFileFromFirebaseStorageParams:
  //             deleteFileFromFirebaseStorageParams);
  //     if (success) {
  //       return const Right(true);
  //     } else {
  //       return Left(FirebaseFailure(
  //           message: 'Failed to delete file on FirebaseStorage'));
  //     }
  //   } catch (e) {
  //     return Left(FirebaseFailure(message: e.toString()));
  //   }
  // }
}
