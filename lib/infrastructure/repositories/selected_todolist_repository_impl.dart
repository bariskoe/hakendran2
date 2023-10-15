import '../../domain/parameters/todo_parameters.dart';
import '../../models/todo_model.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../domain/entities/todolist_entity.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/selected_todolist_repository.dart';
import '../datasources/local_sqlite_datasource.dart';

class SelectedTodoListRepositoryImpl implements SelectedTodolistRepository {
  final LocalSqliteDataSource localSqliteDataSource;
  SelectedTodoListRepositoryImpl({
    required this.localSqliteDataSource,
  });

  @override
  Future<Either<Failure, TodoListEntity>> getSpecificTodoList({
    required String uid,
  }) async {
    try {
      final todoListModel =
          await localSqliteDataSource.getSpecificTodoList(uid: uid);
      if (todoListModel != null) {
        return Right(todoListModel);
      } else {
        return Left(DatabaseFailure());
      }
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> addTodoToSpecificList({
    required TodoParameters todoParameters,
  }) async {
    try {
      final int success = await localSqliteDataSource.addTodoToSpecificList(
          todoModel: TodoModel.fromTodoParameters(todoParameters));
      return Right(success);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> setAccomplishmentStatusOfTodo({
    required String uid,
    required bool accomplished,
  }) async {
    try {
      int changes = await localSqliteDataSource.setAccomplishmentStatusOfTodo(
        uid: uid,
        accomplished: accomplished,
      );
      return Right(changes);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> updateSpecificTodo({
    required TodoParameters todoParameters,
  }) async {
    try {
      int changes = await localSqliteDataSource.updateSpecificTodo(
        todoModel: TodoModel.fromTodoParameters(todoParameters),
      );
      return Right(changes);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> resetAllTodosOfSpecificList({
    required String uid,
  }) async {
    try {
      int changes = await localSqliteDataSource.resetAllTodosOfSpecificList(
        uid: uid,
      );
      return Right(changes);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> addTodoListUidToSyncPendingTodoLists({
    required String uid,
  }) async {
    try {
      int changes =
          await localSqliteDataSource.addTodoListUidToSyncPendingTodoLists(
        uid: uid,
      );
      return Right(changes);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> addTodoUidToSyncPendingTodos(
      {required TodoParameters todoParameters}) async {
    try {
      int changes = await localSqliteDataSource.addTodoUidToSyncPendingTodos(
        todoModel: TodoModel.fromTodoParameters(todoParameters),
      );
      return Right(changes);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> deleteSpecificTodo({
    required TodoParameters todoParameters,
  }) async {
    try {
      int changes = await localSqliteDataSource.deleteSpecificTodo(
        todoModel: TodoModel.fromTodoParameters(todoParameters),
      );
      return Right(changes);
    } catch (e) {
      Logger().e(e);
      return Left(DatabaseFailure());
    }
  }
}
