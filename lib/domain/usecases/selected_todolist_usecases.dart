import '../parameters/todo_parameters.dart';
import '../../models/todo_model.dart';

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
    required String uid,
  }) async {
    return await selectedTodolistRepository.getSpecificTodoList(
      uid: uid,
    );
  }

  Future<Either<Failure, int>> addTodoToSpecificList({
    required TodoParameters todoParameters,
  }) async {
    return await selectedTodolistRepository.addTodoToSpecificList(
      todoParameters: todoParameters,
    );
  }

  Future<Either<Failure, int>> setAccomplishmentStatusOfTodo({
    required String uid,
    required bool accomplished,
  }) async {
    return await selectedTodolistRepository.setAccomplishmentStatusOfTodo(
      uid: uid,
      accomplished: accomplished,
    );
  }

  Future<Either<Failure, int>> updateSpecificTodo({
    required TodoParameters todoParameters,
  }) async {
    return await selectedTodolistRepository.updateSpecificTodo(
      todoParameters: todoParameters,
    );
  }

  Future<Either<Failure, int>> deleteSpecificTodo({
    required TodoParameters todoParameters,
  }) async {
    return await selectedTodolistRepository.deleteSpecificTodo(
      todoParameters: todoParameters,
    );
  }

  Future<Either<Failure, int>> resetAllTodosOfSpecificList({
    required String uid,
  }) async {
    return await selectedTodolistRepository.resetAllTodosOfSpecificList(
      uid: uid,
    );
  }

  Future<Either<Failure, int>> addTodoListUidToSyncPendingTodoLists({
    required String uid,
  }) async {
    return await selectedTodolistRepository
        .addTodoListUidToSyncPendingTodoLists(
      uid: uid,
    );
  }

  Future<Either<Failure, int>> addTodoUidToSyncPendingTodos({
    required TodoParameters todoParameters,
  }) async {
    return await selectedTodolistRepository.addTodoUidToSyncPendingTodos(
        todoParameters: todoParameters);
  }
}
