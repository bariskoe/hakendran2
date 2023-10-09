import 'package:baristodolistapp/models/todo_model.dart';
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
    required TodoModel todoModel,
  }) async {
    try {
      final int success = await localSqliteDataSource.addTodoToSpecificList(
          todoModel: todoModel);
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
    required TodoModel todoModel,
  }) async {
    try {
      int changes = await localSqliteDataSource.updateSpecificTodo(
        todoModel: todoModel,
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
      {required TodoModel todoModel}) async {
    try {
      int changes = await localSqliteDataSource.addTodoUidToSyncPendingTodos(
        todoModel: todoModel,
      );
      return Right(changes);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> deleteSpecificTodo({
    required TodoModel todoModel,
  }) async {
    try {
      int changes = await localSqliteDataSource.deleteSpecificTodo(
        todoModel: todoModel,
      );
      return Right(changes);
    } catch (e) {
      Logger().e(e);
      return Left(DatabaseFailure());
    }
  }
}
