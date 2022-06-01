import 'package:baristodolistapp/models/todo_list_update_model.dart';
import 'package:baristodolistapp/models/todolist_model.dart';

import '../../domain/entities/todolist_entity.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/all_todolists_repository.dart';
import '../datasources/local_sqlite_datasource.dart';
import 'package:dartz/dartz.dart';

class AllTodoListsRepositoryImpl implements AllTodoListsRepository {
  final LocalSqliteDataSource localSqliteDataSource;

  AllTodoListsRepositoryImpl({required final this.localSqliteDataSource});

  @override
  Future<Either<Failure, int>> createNewTodoList({
    required TodoListEntity todoListEntity,
  }) async {
    try {
      final success = await localSqliteDataSource.createNewTodoList(
          todoListEntity: todoListEntity);
      return Right(success);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<TodoListModel>>> getAllTodoLists() async {
    try {
      List<TodoListModel> listOfTodoListModels =
          await localSqliteDataSource.getAllTodoLists();
      return Right(listOfTodoListModels);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> updateSpecificListParameters(
      {required TodoListUpdateModel todoListUpdateModel}) async {
    try {
      int changesMade =
          await localSqliteDataSource.updateSpecificListParameters(
              todoListUpdateModel: todoListUpdateModel);
      return Right(changesMade);
    } catch (e) {
      return left(DatabaseFailure());
    }
  }
}
