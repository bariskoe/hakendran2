import 'package:dartz/dartz.dart';

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
  Future<Either<Failure, TodoListEntity>> getSpecificTodoList(
      {required int id}) async {
    try {
      final todoListModel =
          await localSqliteDataSource.getSpecificTodoList(id: id);
      return Right(todoListModel);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}
