import 'package:baristodolistapp/domain/failures/failures.dart';
import 'package:baristodolistapp/domain/repositories/api_repository.dart';
import 'package:baristodolistapp/infrastructure/datasources/api_datasource.dart';
import 'package:baristodolistapp/models/todo_model.dart';
import 'package:baristodolistapp/models/todolist_model.dart';
import 'package:dartz/dartz.dart';

import '../../models/api_action_model.dart';

class ApiRepositoryImpl implements ApiRepository {
  final ApiDatasource apiDatasource;

  ApiRepositoryImpl({required this.apiDatasource});

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
  Future<Either<Failure, bool>> createTodoList(
      {required TodoListModel todoListModel}) async {
    try {
      final uploadSuccessful = await apiDatasource.createTodoList(
        todoListModel: todoListModel,
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
