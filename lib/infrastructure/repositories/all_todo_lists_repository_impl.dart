import 'package:baristodolistapp/domain/entities/todolist_entity.dart';
import 'package:baristodolistapp/domain/failures/failures.dart';
import 'package:baristodolistapp/domain/repositories/all_todolists_repository.dart';
import 'package:baristodolistapp/infrastructure/datasources/local_sqlite_datasource.dart';
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
}
