import 'package:baristodolistapp/domain/parameters/todo_parameters.dart';

import '../../domain/failures/failures.dart';
import '../../domain/parameters/todolist_entity_parameters.dart';
import '../../domain/repositories/api_repository.dart';
import '../datasources/api_datasource.dart';
import '../../models/todo_model.dart';
import '../../models/todolist_model.dart';
import 'package:dartz/dartz.dart';

import '../../models/api_action_model.dart';

class ApiRepositoryImpl implements ApiRepository {
  final ApiDatasource apiDatasource;

  ApiRepositoryImpl({required this.apiDatasource});

  @override
  Future<Either<Failure, bool>> addTodoToSpecificList(
      {required TodoParameters todoParameters}) async {
    try {
      final uploadSuccessful = await apiDatasource.addTodoToSpecificList(
          todoModel: TodoModel.fromTodoParameters(todoParameters));
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
}
