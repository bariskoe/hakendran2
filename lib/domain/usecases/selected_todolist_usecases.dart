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
    required String uuid,
  }) async {
    return await selectedTodolistRepository.getSpecificTodoList(
      uuid: uuid,
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
    required String uuid,
    required bool accomplished,
  }) async {
    return await selectedTodolistRepository.setAccomplishmentStatusOfTodo(
      uuid: uuid,
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
    required String uuid,
  }) async {
    return await selectedTodolistRepository.resetAllTodosOfSpecificList(
      uuid: uuid,
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
}
