import '../entities/todolist_entity.dart';
import 'package:dartz/dartz.dart';

import '../failures/failures.dart';

abstract class AllTodoListsRepository {
  /// Calls a function in DatabaseHelper to create a new TodoList.
  /// Returns an [int] if the TodoList was saved successfully.
  /// Returns a [DatabaseFailure] if no int is returned from Database
  /// it will return a [GenralFailure] for all other failures
  Future<Either<Failure, int>> createNewTodoList(
      {required TodoListEntity todoListEntity});
}
