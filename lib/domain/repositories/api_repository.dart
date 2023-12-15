import 'package:baristodolistapp/domain/parameters/upload_to_firebase_storage_parameters.dart';
import 'package:dartz/dartz.dart';

import '../../models/api_action_model.dart';
import '../../models/todo_model.dart';
import '../failures/failures.dart';
import '../parameters/delete_file_from_firebase_storage_params.dart';

import '../parameters/todolist_entity_parameters.dart';

abstract class ApiRepository {
  Future<Either<Failure, bool>> createTodoList({
    required TodoListEntityParameters todoListEntityParameters,
  });

  Future<Either<Failure, bool>> addTodoToSpecificList({
    required TodoModel todoModel,
  });

  Future<Either<Failure, bool>> performApiAction({
    required ApiActionModel apiActionModel,
  });

  Future<Either<Failure, String>> uploadToFirebaseStorage({
    required UploadToFirebaseStorageParameters
        uploadToFirebaseStorageParameters,
  });

  Future<Either<Failure, bool>> deleteFileFromFirebaseStorage({
    required DeleteFileFromFirebaseStorageParams
        deleteFileFromFirebaseStorageParams,
  });
}
