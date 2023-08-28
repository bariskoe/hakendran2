import 'package:baristodolistapp/models/todo_model.dart';

import '../entities/todolist_entity.dart';
import '../failures/failures.dart';
import 'package:dartz/dartz.dart';

abstract class SelectedTodolistRepository {
  Future<Either<Failure, TodoListEntity>> getSpecificTodoList({
    required String uuid,
  });

  Future<Either<Failure, int>> addTodoToSpecificList({
    required TodoModel todoModel,
  });

  Future<Either<Failure, int>> setAccomplishmentStatusOfTodo({
    required String uuid,
    required bool accomplished,
  });

  Future<Either<Failure, int>> updateSpecificTodo({
    required TodoModel todoModel,
  });

  Future<Either<Failure, int>> resetAllTodosOfSpecificList({
    required String uuid,
  });
}
