import 'package:baristodolistapp/models/todo_model.dart';

import '../entities/todolist_entity.dart';
import '../failures/failures.dart';
import '../repositories/selected_todolist_repository.dart';
import 'package:dartz/dartz.dart';

class SelectedTodolistUsecases {
  final SelectedTodolistRepository selectedTodolistRepository;
  SelectedTodolistUsecases({
    required this.selectedTodolistRepository,
  });

  Future<Either<Failure, TodoListEntity>> getSpecificTodoList({
    required int id,
  }) async {
    return await selectedTodolistRepository.getSpecificTodoList(
      id: id,
    );
  }

  Future<Either<Failure, int>> addTodoToSpecificList({
    required TodoModel todoModel,
  }) async {
    return await selectedTodolistRepository.addTodoToSpecificList(
      todoModel: todoModel,
    );
  }

  Future<Either<Failure, int>> setAccomplishmentStatusOfTodo({
    required int id,
    required bool accomplished,
  }) async {
    return await selectedTodolistRepository.setAccomplishmentStatusOfTodo(
      id: id,
      accomplished: accomplished,
    );
  }

  Future<Either<Failure, int>> updateSpecificTodo({
    required TodoModel todoModel,
  }) async {
    return await selectedTodolistRepository.updateSpecificTodo(
      todoModel: todoModel,
    );
  }

  Future<Either<Failure, int>> resetAllTodosOfSpecificList({
    required int id,
  }) async {
    return await selectedTodolistRepository.resetAllTodosOfSpecificList(
      id: id,
    );
  }
}
