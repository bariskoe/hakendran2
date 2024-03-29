import 'package:dartz/dartz.dart';

import '../../models/todo_model.dart';
import '../entities/todolist_entity.dart';
import '../failures/failures.dart';
import '../parameters/todo_parameters.dart';
import '../parameters/todo_update_parameters.dart';

abstract class SelectedTodolistRepository {
  Future<Either<Failure, TodoListEntity>> getSpecificTodoList({
    required String uid,
  });

  Future<Either<Failure, int>> addTodoToSpecificList({
    required TodoModel todoModel,
  });

  Future<Either<Failure, int>> setAccomplishmentStatusOfTodo({
    required String uid,
    required bool accomplished,
  });

  Future<Either<Failure, int>> updateSpecificTodo({
    required TodoUpdateParameters todoUpdateParameters,
  });

  Future<Either<Failure, int>> deleteSpecificTodo({
    required TodoParameters todoParameters,
  });

  Future<Either<Failure, int>> resetAllTodosOfSpecificList({
    required String uid,
  });
  Future<Either<Failure, int>> addTodoListUidToSyncPendingTodoLists({
    required String uid,
  });
  Future<Either<Failure, int>> addTodoUidToSyncPendingTodos({
    required TodoParameters todoParameters,
  });
}
